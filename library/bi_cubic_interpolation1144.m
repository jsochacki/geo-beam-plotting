function result = bi_cubic_interpolation1144(point, data, rows, columns)
   % point is [R C] coordinate of the point where R is the value to search
   %   for in the row vector and C is the value to search for in the columns
   %   vector
   % data is the data in matrix format
   % rows is the row locations of the data
   % columns is the column locations of the data
   
   R = point(1); C = point(2);
   
   % First make sure the data is in the rows and columns range
   rmin = min(rows); rmax = max(rows); cmin = min(columns); cmax = max(columns);
   if~((rmin <= R) & (R <= rmax))
      sprintf('R value is %f but needs to be between %f and %f\n', R, rmin, rmax)
      result = -Inf;
      return;
   end
   if~((cmin <= C) & (C <= cmax))
      sprintf('C value is %f but needs to be between %f and %f\n', C, cmin, cmax)
      result = -Inf;
      return;
   end
   
   % Reduce the size of the data you are playing with
   [~, rtempindex] = sort(abs(rows - R));
   [~, ctempindex] = sort(abs(columns - C));
   rtempindexs = sort(rtempindex(1:1:4));
   ctempindexs = sort(ctempindex(1:1:4));
   rvals = rows(rtempindexs);
   cvals = columns(ctempindexs);
   data_grid = data(rtempindexs, ctempindexs);
   
   % Format so that rows and columns are ascending in value towards end
   if(rvals(1) > rvals(end))
      data_grid = flipud(data_grid);
      rvals = fliplr(rvals);
   end
   if(cvals(1) > cvals(end))
      data_grid = fliplr(data_grid);
      cvals = fliplr(cvals);
   end
   
   % Calculate r and c
   [~, rtempindex] = sort(abs(rvals - R));
   [~, ctempindex] = sort(abs(cvals - C));
   rdeltas = R - rvals;
   cdeltas = C - cvals;
   rstep = abs(rvals(rtempindex(1)) - rvals(rtempindex(2)));
   cstep = abs(cvals(ctempindex(1)) - cvals(ctempindex(2)));
   r = rtempindex(1) + (rdeltas(rtempindex(1)) / rstep);
   c = ctempindex(1) + (cdeltas(ctempindex(1)) / cstep);

   for n = 1:1:4
      sum = 0;
      for m = 1:1:4
         sum = sum + (data_grid(n, m) * K_bi_cubic_interpolation1144(c - m));
      end
      Csum(n) = sum;
   end

   result = 0;
   for n = 1:1:4
      result = result + (Csum(n) * K_bi_cubic_interpolation1144(r - n));
   end
end