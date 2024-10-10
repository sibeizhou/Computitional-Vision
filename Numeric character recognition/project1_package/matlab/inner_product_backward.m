function [param_grad, input_od] = inner_product_backward(output, input, layer, param)

% Replace the following lines with your implementation.
s = size(output.diff);
param_grad.b = (output.diff * ones(s(2),1)).';
param_grad.w =  input.data * output.diff.';
input_od = param.w * output.diff;
end
