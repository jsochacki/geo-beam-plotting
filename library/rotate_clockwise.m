function rotated_points = rotate_clockwise(points, angle_in_deg)
%%
% Takes a shape that is specified with x y coordinates in points and rotates it
% Only works if shape is centered around zero

if (size(points,2) > size(points, 1))
   points = points.';
end

if (size(angle_in_deg,2) > size(angle_in_deg, 1))
   angle_in_deg = angle_in_deg.';
end

if (length(angle_in_deg) == size(points, 1))
   alpha = (pi / 180) * angle_in_deg;
   rotated_points(:,1) = (points(:,1) .* cos(alpha)) + (points(:,2) .* sin(alpha));
   rotated_points(:,2) = (points(:,1) .* -sin(alpha)) + (points(:,2) .* cos(alpha));
else
   alpha = (pi / 180) * angle_in_deg;
   R  = [cos(alpha) sin(alpha); ...
         -sin(alpha) cos(alpha)];
   rotated_points = (R * [points(:,1).' ; points(:,2).']).';   
end

end