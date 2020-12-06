function extracted_water=haar_extract(img,l) %watermark extraction

input=imread('lena_gray_512.tif'); %cover image
input=rgb2gray(input); %convert colour image to grayscale image
input=imresize(input,[512,512]); %image resize
figure,imshow(input);title('Cover image');
[LL,LH,HL,HH] = haart2(input,1); %perform 1-level haar DWT on cover image
input=(HH);
output=imresize(img,[512,512]);
[new_LL,new_LH,new_HL,new_HH] = haart2(output,1); %perform 1-level haar DWT on embedded image
output=(new_HH);
extracted =zeros(256,256); 

% Get height and width for traversing through the image 
height = size(output, 1); 
width = size(output, 2); 
% Counter for number of embedded bits 
extracted_water='';
embed_counter = 1; 
len=l;%size of entire watermark
% Traverse through the image 
for i = 1 : height 
    for j = 1 : width 
          
        % If there are more bits remaining to embed 
        if(embed_counter <= len) 
              
            % Finding Least Significant Bit of the current pixel 
            LSB = mod(double(input(i, j)), 2); 
            ls= mod(double(output(i, j)), 2); 
            % Find whether the bit is same or needs to change 
      
             temp = output(i,j) -input(i, j);
             %temp_array2(embed_counter)=temp;

             extracted_water=strcat(extracted_water,dec2bin(xor(temp,LSB)));
             extracted(i, j) = output(i, j)-temp;
              
            % Increment the embed counter 
            embed_counter = embed_counter+1; 
        else
            extracted(i, j) = output(i, j);
        end
          
    end
end
ex_img = ihaart2(new_LL,new_LH,new_HL,extracted); %inverse 1- level haar DWT
extracted=uint8(ex_img);
figure,imshow(extracted);title('Extracted input image');
end