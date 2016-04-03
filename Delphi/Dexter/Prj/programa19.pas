program programa19;
var
  i, j, k, l, m, n, o, p, q, r, s: Integer;
begin
  WriteLn('inicio...');
  for (i:= 1; i <= 3; i:= i + 1) do
    for (j:= 1; j <= 2; j:= j + 1) do
      for (k:= 1; k <= 3; k:= k + 1) do
        for (l:= 1; l <= 1; l:= l + 1) do
          for (m:= 1; m <= 1; m:= m + 1) do
            for (n:= 1; n <= 1; n:= n + 1) do
              for (o:= 1; o <= 1; o:= o + 1) do
                for (p:= 1; p <= 1; p:= p + 1) do
                  for (q:= 1; q <= 1; q:= q + 1) do
                    for (r:= 1; r <= 1; r:= r + 1) do
                      for (s:= 1; s <= 1; s:= s + 1) do
                        WriteLn('Result: ', i + j + k + l + m + n + o + p + q + r + s);
  WriteLn('fim...');
end.