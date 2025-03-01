function m_matrix = rotated_matrix(v_vector)
% Length of A
n_lines= size(v_vector)(1);

% Initialize the matrix M
m_matrix = zeros(n_lines, n_lines);

% Populate the matrix M
for n_i = 1:n_lines
    m_matrix(:, n_i) = circshift(v_vector, n_i-1);  % Rotate A by (i-1) positions
end
end
