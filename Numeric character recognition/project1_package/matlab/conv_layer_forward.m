function [output] = conv_layer_forward(input, layer, param)
% Conv layer forward
% input: struct with input data
% layer: convolution layer struct
% param: weights for the convolution layer

% output: 

h_in = input.height;
w_in = input.width;
c = input.channel;
batch_size = input.batch_size;
k = layer.k;
pad = layer.pad;
stride = layer.stride;
num = layer.num;
% resolve output shape
h_out = (h_in + 2*pad - k) / stride + 1;
w_out = (w_in + 2*pad - k) / stride + 1;

assert(h_out == floor(h_out), 'h_out is not integer')
assert(w_out == floor(w_out), 'w_out is not integer')
input_n.height = h_in;
input_n.width = w_in;
input_n.channel = c;

%% Fill in the code
% Iterate over the each image in the batch, compute response,
% Fill in the output datastructure with data, and the shape. 
output.height = h_out;
output.width = w_out;
output.channel = num;
output.batch_size = batch_size;

output.data = zeros([h_out*w_out*num, batch_size]);
% tmp = input;
for batch = 1:batch_size
    each_img.data = input.data(:, batch);
    each_img.height = h_in;
    each_img.width = w_in;
    each_img.channel = c;

    img = im2col_conv(each_img, layer, h_out, w_out);
    img = reshape(img, c*k*k, h_out*w_out);
    result_tmp = img.' * param.w + param.b;
    result = reshape(result_tmp, h_out, w_out, layer.num);
    output.data(:, batch) = reshape(result, [], 1);
end

end

