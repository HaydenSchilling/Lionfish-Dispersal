#!home/z3374139/parcels_env/bin/python3

from parcels import FieldSet, Field, AdvectionRK4, ParticleSet, JITParticle, Variable, DiffusionUniformKh, random#, plotTrajectoriesFile
from parcels import ErrorCode
import numpy as np
from glob import glob
from datetime import timedelta as delta
from datetime import datetime as datetime
import os
import math
from operator import attrgetter
#import cartopy
#import netCDF4
import pandas as pd

filenames = {'U': sorted((glob('/srv/scratch/z3374139/Lionfish/Sea_Data/Med_29m*'))), 
             'V': sorted((glob('/srv/scratch/z3374139/Lionfish/Sea_Data/Med_29m*'))),
             'bathy': '/srv/scratch/z3374139/Lionfish/Sea_Data/MED-MFC_006_013_mask_bathy.nc'}#,
             #'temp': (glob('/Users/htsch/Documents/GitHub/Lionfish-Dispersal/Data/Temp_*'))}


array_ref = int(os.environ['PBS_ARRAY_INDEX']) # 19 zones by 10 years = 190 = 0-189


variables = {'U': 'vozocrtx',
             'V': 'vomecrty',
             'bathy': 'deptho'}#,
             #'temp': 'votemper'}

dimensions = {}
dimensions['U'] = {'lat': 'lat', 'lon': 'lon', 'depth': 'depth', 'time': 'time'}
dimensions['V'] = {'lat': 'lat', 'lon': 'lon', 'depth': 'depth', 'time': 'time'}
dimensions['bathy'] = {'lat': 'latitude', 'lon': 'longitude'} 
#dimensions['temp'] = {'lat': 'lat', 'lon': 'lon', 'depth': 'depth', 'time': 'time'} 

#indices = {'depth': [0]}

# Set diffusion constants.
Kh_zonal = 10
Kh_meridional = 10

# Make fieldset
fieldset = FieldSet.from_netcdf(filenames, variables, dimensions, allow_time_extrapolation = True)

fieldset.add_constant('maxage', 26.*86400)
#fieldset.temp.interp_method = 'nearest'


Points = pd.read_csv("/srv/scratch/z3374139/Lionfish/Forward/From 2026/Shallow_end_points_reduced.csv")
lon_array = Points['lon'].to_list()
lat_array = Points['lat'].to_list()



#lon = lon_array[array_ref] * np.ones(npart)
#lat = lat_array[array_ref] * np.ones(npart)


npart = 80  # number of particles to be released

# Number of repeated releases - this is now taken from our run time function by runtime.days
repeats = 91 # This is the difference in days between # datetime(2012,7,31) - datetime(2012,5,1)
# Random lat/lon within each Ocean Zone
# List of random points

# Particle release times.
pset_start = (datetime(2020,5,1) - datetime.strptime(str(fieldset.time_origin)[0:10], "%Y-%m-%d")).total_seconds()  # Start time (in seconds since fieldset start).
repeat_dt = delta(days=1)  # Repeat frequency
# Create array of release times (use minus for back tracking).
release_times = pset_start + (np.arange(0, repeats) * repeat_dt.total_seconds())
# Duplicate each release time for each repeat of lat/lon values.
time = np.repeat(release_times, npart)


# make lengths of locations

lon = np.repeat(lon_array[array_ref],repeats*npart)
lat = np.repeat(lat_array[array_ref],repeats*npart)


repeatdt = delta(days=1)  # release from the same set of locations every X day

# Forward: 9
# lon_array = [153.8072, 153.5873, 153.5460, 153.6929, 153.7817, 153.7955, 153.7790, 153.7062, 153.5131]
# lat_array = [-26.0, -26.5, -27.0, -27.5, -28.0, -28.5, -29.0, -29.50, -30.00]

# Backwards: 13
#lon_array = [150.8550, 151.4167, 152.8444, 150.2451, 153.7313, 153.7861, 148.9148, 150.1600, 150.3833, 153.0958, 153.3182, 153.8036, 153.6422]
#lat_array = [-35.1, -33.8, -32, -36.2, -29.4, -28.1, -38, -37, -35.7, -31.4, -30.4, -28.8, -27.3]

#lon_array = [150.8550 , 151.4167, 152.8444, 150.2451]#, 153.7313, 153.7861, 148.9148, 150.1600, 150.3833, 153.0958, 153.3182, 153.8036, 153.6422]
#lat_array = [-35.1, -33.8, -32, -36.2]#, -29.4, -28.1, -38, -37, -35.7, -31.4, -30.4, -28.8, -27.3]


# year_array = np.arange(2012, 2016, 1)

# start_time = datetime(year_array[array_ref],1, 2)
# end_time = datetime(year_array[array_ref],1, 30)  #year, month, day,

# runtime = end_time-start_time + delta(days=1)


# Diffusion
size2D = (fieldset.U.grid.ydim, fieldset.U.grid.xdim)
fieldset.add_field(Field('Kh_zonal', Kh_zonal*np.ones(size2D), 
                         lon=fieldset.U.grid.lon, lat=fieldset.U.grid.lat, mesh='spherical'))
fieldset.add_field(Field('Kh_meridional', Kh_meridional*np.ones(size2D), 
                         lon=fieldset.U.grid.lon, lat=fieldset.U.grid.lat, mesh='spherical'))

random.seed(123456) # Set random seed

class SampleParticle(JITParticle):         # Define a new particle class
    age = Variable('age', dtype=np.float32, initial=0.) # initialise age
    #temp = Variable('temp', dtype=np.float32, initial=fieldset.temp)  # initialise temperature
    bathy = Variable('bathy', dtype=np.float32, initial=0)  # initialise bathy
    distance = Variable('distance', initial=0., dtype=np.float32)  # the distance travelled
    prev_lon = Variable('prev_lon', dtype=np.float32, to_write=False,
                        initial=attrgetter('lon'))  # the previous longitude
    prev_lat = Variable('prev_lat', dtype=np.float32, to_write=False,
                        initial=attrgetter('lat'))  # the previous latitude.


def SampleDistance(particle, fieldset, time):
    # Calculate the distance in latitudinal direction (using 1.11e2 kilometer per degree latitude)
    lat_dist = (particle.lat - particle.prev_lat) * 1.11e2
    # Calculate the distance in longitudinal direction, using cosine(latitude) - spherical earth
    lon_dist = (particle.lon - particle.prev_lon) * 1.11e2 * math.cos(particle.lat * math.pi / 180)
    # Calculate the total Euclidean distance travelled by the particle
    particle.distance += math.sqrt(math.pow(lon_dist, 2) + math.pow(lat_dist, 2))
    particle.prev_lon = particle.lon  # Set the stored values for next iteration.
    particle.prev_lat = particle.lat
    
def DeleteParticle(particle, fieldset, time):
    particle.delete()
    
def SampleAge(particle, fieldset, time):
    particle.age = particle.age + math.fabs(particle.dt)
    if particle.age > fieldset.maxage:
        particle.delete()
        
def SampleBathy(particle, fieldset, time):
    particle.bathy = fieldset.bathy[0, 0, particle.lat, particle.lon]

#def SampleTemp(particle, fieldset, time):
#    particle.temp = fieldset.temp[time, particle.depth, particle.lat, particle.lon]


#end_time = np.repeat(end_time,len(lon))
#start_time = np.repeat(start_time,len(lon))

pset = ParticleSet.from_list(pclass=SampleParticle, fieldset=fieldset,
                              lon=lon, lat=lat, time=time, repeatdt=None)
#pset = ParticleSet.from_list(fieldset, pclass=SampleParticle,time = start_time, lon=lon, lat=lat, repeatdt=repeatdt) #, time=start_time

#pset.show()

#pset.show(domain={'N':36, 'S':30.2, 'E':36.25, 'W':30}) #

#out_file = "/Users/hayde/Portunid-Dispersal/portunid_particle_tracking/BRAN/Output/BRAN_Test_output.nc"
out_file = "/srv/scratch/z3374139/Lionfish/Forward/From 2027/2027__Main_Spawning_" + str(array_ref) +".nc"
pfile = pset.ParticleFile(out_file, outputdt=delta(days=1))

if os.path.exists(out_file):
    os.remove(out_file)



kernels = pset.Kernel(AdvectionRK4) +  SampleAge +  SampleDistance + DiffusionUniformKh + SampleBathy#+ SampleTemp#  + 

#pset.show()

pset.execute(kernels, 
              dt=delta(minutes=5), 
              output_file=pfile, 
              verbose_progress=True,
              #moviedt=delta(hours=1),
              #endtime=datetime(2013,5,1)+delta(days=91)+delta(days=26),
              runtime = delta(days=(91+26)),
              recovery={ErrorCode.ErrorOutOfBounds: DeleteParticle})
pfile.close()




#pset.show(domain={'N':36, 'S':30.2, 'E':36.25, 'W':30}, field='vector') #


#plotTrajectoriesFile("/Users/htsch/Documents/GitHub/Lionfish-Dispersal/Output/Med_Test_output1.nc")

#fieldset.U.show(domain={'N':36, 'S':30.2, 'E':36.25, 'W':30})
#fieldset.temp.show(domain={'N':-20, 'S':-35, 'E':157, 'W':150})
#fieldset.V.show(domain={'N':36, 'S':30.2, 'E':36.25, 'W':30})
#pset.show(domain={'N':36, 'S':30.2, 'E':36.25, 'W':30}, field='vector') #, projection=cartopy.crs.EqualEarth()

# #### Now repeat for rest of the year ###########################

# random.seed(12345) # Set random seed

# npart2 = 2
# # Number of repeated releases - this is now taken from our run time function by runtime.days
# repeats2 = 152 # results of # datetime(2012,12,31) - datetime(2012,8,1)
# # Random lat/lon within each Ocean Zone
# # List of random points

# # Particle release times.
# pset_start2 = (datetime(2013,8,1) - datetime.strptime(str(fieldset.time_origin)[0:10], "%Y-%m-%d")).total_seconds()  # Start time (in seconds since fieldset start).
# repeat_dt2 = delta(days=1)  # Repeat frequency
# # Create array of release times (use minus for back tracking).
# release_times2 = pset_start2 + (np.arange(0, repeats2) * repeat_dt2.total_seconds())
# # Duplicate each release time for each repeat of lat/lon values.
# time2 = np.repeat(release_times2, npart2)

# # make lengths of locations

# lon2 = np.repeat(lon_array[array_ref],repeats2*npart2)
# lat2 = np.repeat(lat_array[array_ref],repeats2*npart2)


# pset = ParticleSet.from_list(pclass=SampleParticle, fieldset=fieldset,
#                              lon=lon2, lat=lat2, time=time2, repeatdt=None)
# #pset = ParticleSet.from_list(fieldset, pclass=SampleParticle,time = start_time, lon=lon, lat=lat, repeatdt=repeatdt) #, time=start_time

# #pset.show()

# #pset.show(domain={'N':36, 'S':30.2, 'E':36.25, 'W':30}) #

# out_file2 = "/srv/scratch/z3374139/Lionfish/2013/2013_after_main_spawning_" + str(array_ref) +".nc"
# pfile2 = pset.ParticleFile(out_file2, outputdt=delta(days=1))

# if os.path.exists(out_file2):
#     os.remove(out_file2)



# kernels = pset.Kernel(AdvectionRK4) +  SampleAge +  SampleDistance + DiffusionUniformKh #+ SampleTemp#SampleBathy  + 

# #pset.show()

# pset.execute(kernels, 
#              dt=delta(minutes=5), 
#              output_file=pfile2, 
#              verbose_progress=True,
#              #moviedt=delta(hours=1),
#              #endtime=datetime(2012,8,1)+delta(days=152)+delta(days=26),
#              runtime = delta(days=(152+26)),
#              recovery={ErrorCode.ErrorOutOfBounds: DeleteParticle})
# pfile2.close()



#plotTrajectoriesFile("/Users/htsch/Documents/GitHub/Lionfish-Dispersal/Output/Med_Test_output2.nc")
#plotTrajectoriesFile("/Users/hayde/Portunid-Dispersal/portunid_particle_tracking/BRAN/Output/BRAN_Test_output.nc");

#fieldset.U.show(domain={'N':36, 'S':30.2, 'E':36.25, 'W':30})
#fieldset.temp.show(domain={'N':-20, 'S':-35, 'E':157, 'W':150})
#fieldset.V.show(domain={'N':36, 'S':30.2, 'E':36.25, 'W':30})
#pset.show(domain={'N':36, 'S':30.2, 'E':36.25, 'W':30}, field='vector') #, projection=cartopy.crs.EqualEarth()


# # Now do beginning of the year
# random.seed(1234) # Set random seed

# npart3 = 2
# # Number of repeated releases - this is now taken from our run time function by runtime.days
# repeats3 = 120 # results of # datetime(2013,5,1) - datetime(2013,1,1)
# # Random lat/lon within each Ocean Zone
# # List of random points

# # Particle release times.
# pset_start3 = (datetime(2013,1,1) - datetime.strptime(str(fieldset.time_origin)[0:10], "%Y-%m-%d")).total_seconds()  # Start time (in seconds since fieldset start).
# repeat_dt3 = delta(days=1)  # Repeat frequency
# # Create array of release times (use minus for back tracking).
# release_times3 = pset_start3 + (np.arange(0, repeats3) * repeat_dt3.total_seconds())
# # Duplicate each release time for each repeat of lat/lon values.
# time3 = np.repeat(release_times3, npart3)

# # make lengths of locations

# lon3 = np.repeat(lon_array[array_ref],repeats3*npart3)
# lat3 = np.repeat(lat_array[array_ref],repeats3*npart3)


# pset = ParticleSet.from_list(pclass=SampleParticle, fieldset=fieldset,
#                              lon=lon3, lat=lat3, time=time3, repeatdt=None)
# #pset = ParticleSet.from_list(fieldset, pclass=SampleParticle,time = start_time, lon=lon, lat=lat, repeatdt=repeatdt) #, time=start_time

# #pset.show()

# #pset.show(domain={'N':36, 'S':30.2, 'E':36.25, 'W':30}) #

# out_file3 = "/srv/scratch/z3374139/Lionfish/2013/2013_before_main_spawning_" + str(array_ref) +".nc"
# pfile3 = pset.ParticleFile(out_file3, outputdt=delta(days=1))

# if os.path.exists(out_file3):
#     os.remove(out_file3)



# kernels = pset.Kernel(AdvectionRK4) +  SampleAge +  SampleDistance + DiffusionUniformKh #+ SampleTemp#SampleBathy  + 

# #pset.show()

# pset.execute(kernels, 
#              dt=delta(minutes=5), 
#              output_file=pfile2, 
#              verbose_progress=True,
#              #moviedt=delta(hours=1),
#              #endtime=datetime(2012,8,1)+delta(days=152)+delta(days=26),
#              runtime = delta(days=(120+26)),
#              recovery={ErrorCode.ErrorOutOfBounds: DeleteParticle})
# pfile3.close()


