function [output] = pooling_layer_forward(input, layer)

    h_in = input.height;
    w_in = input.width;
    c = input.channel;
    batch_size = input.batch_size;
    k = layer.k;
    pad = layer.pad;
    stride = layer.stride;
    
    h_out = (h_in + 2*pad - k) / stride + 1;
    w_out = (w_in + 2*pad - k) / stride + 1;
    
    
    output.height = h_out;
    output.width = w_out;
    output.channel = c;
    output.batch_size = batch_size;

    % Replace the following line with your implementation.
    output.data = zeros([h_out*w_out*c, batch_size]);
    each_img.data = zeros([h_out,w_out,c]);
    each_img.height = h_out;
    each_img.width = w_out;
    each_img.channel = c;

    for b = 1:batch_size
        img_data = reshape(input.data(:, b), input.height, input.width, input.channel);
        img_data = padarray(img_data, [pad, pad]);
        s = size(img_data);
        for channel = 1:c
            h_i = 1;
            for h = 1: stride: s(1)
                w_i = 1;
               for w = 1: stride : s(2)
                    each_img.data(h_i, w_i, channel) = max(img_data(h: h+k-1, w: w+k-1, channel),[], 'all');
                    w_i = w_i +1;
                end
                h_i = h_i +1;
            end
        end
        output.data(:, b) = reshape(each_img.data, [], h_out*w_out*c);
    end
end

