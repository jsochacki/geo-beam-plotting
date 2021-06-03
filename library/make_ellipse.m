function points = make_ellipse(xoffset, yoffset, xradius, yradius, Npoints)
   [X,Y,Z] = ellipsoid(xoffset,yoffset,0,xradius,yradius,1,Npoints);
   indicies = find(Z==0);
   points = [X(indicies) Y(indicies)];
end