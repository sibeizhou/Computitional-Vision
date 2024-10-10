% Q3.3.1
close all;
clear all;

bookMov = loadVid('../data/book.mov');
srcMov = loadVid('../data/ar_source.mov');
cover_img = imread('../data/cv_cover.jpg');

vid = VideoWriter('../results/ar.avi');
open(vid);

numFrames = min(size(bookMov, 2), size(srcMov, 2));
for i = 1:numFrames
    book_frame = bookMov(i).cdata; % read book image

    src_frame = srcMov(i).cdata; % read source image
    
    height = size(src_frame, 1);
    width = size(cover_img, 2)*height/size(cover_img, 1);
    x = floor((size(src_frame, 2)-width)/2);
    src_frame_crop = imcrop(src_frame, [x 0 width height]);

    [locs1, locs2] = matchPics(cover_img, book_frame);
    [bestH2to1, ~] = computeH_ransac(locs1, locs2);
    
    scaled_hp_img = imresize(src_frame_crop, [size(cover_img,1) size(cover_img,2)]);

    imshow(compositeH(bestH2to1.', scaled_hp_img, book_frame));
    filename = "../results/ar/" + i + ".jpg";
    saveas(gcf, filename);

    writeVideo(vid, compositeH(bestH2to1.', scaled_hp_img, book_frame));
end

close(vid);