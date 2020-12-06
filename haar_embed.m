function haar_embed(watermark) %watermark embedding
    input=imread('lena_gray_512.tif'); %cover image
    input=rgb2gray(input); %convert colour image to grayscale image
    input=imresize(input,[512,512]); %image resize
    figure,imshow(input);title('Cover image');
    [LL,LH,HL,HH] = haart2(input,1); %perform 1-level haar DWT
    input=(HH);
    
    % Initialize output as input 
    output =zeros(256,256); 

    % Get height and width for traversing through the image 
    height = size(input, 1); 
    width = size(input, 2); 
    % Counter for number of embedded bits 
      embed_counter = 1; 
      len=length(watermark); %give size of the total watermark here
      k=0;
    % Traverse through the image 
    for i = 1 : height    
        for j = 1 : width 

            % If there are more bits remaining to embed 
            if(embed_counter <= len) 
                  k=k+1
                % Find Least Significant Bit of the current pixel 
                LSB = mod(double(input(i, j)), 2); 

                % LSB Embedding 
                temp = double(xor(LSB,double(watermark(k))-48)); 
                output(i, j) = input(i, j)+temp; 

                embed_counter = embed_counter+1; 

            else
                 output(i, j) = input(i, j); 
            end
        end
    end
    new_img = ihaart2(LL,LH,HL,output); %inverse 1- level haar DWT
    new_img=uint8(new_img);
    imwrite(new_img,'C:\Users\nikhi\Desktop\project\Segmentation\watermarked\embedded.bmp')
    figure,imshow(new_img);title('Reconstructed');

end