function bearings = get_initial_bearing(starting_points, ...
                                        ending_points)

%%
% Bearings are from tdc i.e. north is 0 degrees , East is 90 and West is -90
%

if (((size(starting_points,2) > size(starting_points,1))) & (size(starting_points,1) ~= 1))
   starting_points = starting_points.';
end

if (((size(ending_points,2) > size(ending_points,1))) & (size(ending_points,1) ~= 1))
   ending_points = ending_points.';
end

sradlats = starting_points(:,2) * (pi / 180);
sradlons = starting_points(:,1) * (pi / 180);
eradlats = ending_points(:,2) * (pi / 180);
eradlons = ending_points(:,1) * (pi / 180);

dradlons = eradlons - sradlons;

bearings = atan2(sin(dradlons) .* cos(eradlats), ...
                 (cos(sradlats) .* sin(eradlats)) ...
                  - (sin(sradlats) .* cos(eradlats) .* cos(dradlons)));

bearings = bearings * (180 / pi);

end