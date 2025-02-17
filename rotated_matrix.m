function m = rotated_matrix(c)
% Length of A
n = length(c);

% Initialize the matrix M
m = zeros(n, n);

% Populate the matrix M
for i = 1:n
    m(:, i) = circshift(c, i-1);  % Rotate A by (i-1) positions
end
end
