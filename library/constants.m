function [ constant ] = constants(constant_type, constant_name)

   switch constant_type
      case 'physics'
         switch constant_name
            case 'speed_of_light_in_m'
               constant = 299792458.0;
            case 'boltzmanns_constant'
               constant = 1.38064852e-23;
            case 'zero_C_in_kelvin'
               constant = 273.15;
            case 'room_temp_in_C'
               constant = 16.85;
            case 'room_temp_in_K'
               constant = 290.0;
            otherwise
               sprintf('The constant you have requested, %s, is not defined', constant_name)
               constant = nan;
         end
      case 'geographical'
         switch constant_name
            case 'mean_earth_radius_in_m'
               constant = 6371000;
            case 'polar_earth_radius_in_m'
               constant = 6356000;
            case 'equatorial_earth_radius_in_m'
               constant = 6378000;
            case 'mean_geosynchronous_orbit_distance_from_equator_in_m'
               constant = 35786000;
            otherwise
               sprintf('The constant you have requested, %s, is not defined', constant_name)
               constant = nan;
         end
      case 'orbital'
         switch constant_name
            case 'mean_geosynchronous_orbit_distance_from_equator_in_m'
               constant = 35786000;
            otherwise
               sprintf('The constant you have requested, %s, is not defined', constant_name)
               constant = nan;
         end
      otherwise
         sprintf('The constant type you have requested, %s, is not defined', constant_type)
         constant = nan;
   end

end
