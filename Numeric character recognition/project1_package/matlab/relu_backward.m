function [input_od] = relu_backward(output, input, layer)

% Replace the following line with your implementation.
equal_to = (max(input.data, 0) == input.data); 
input_od = output.diff .* equal_to;
end
