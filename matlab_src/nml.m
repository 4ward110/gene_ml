function [outputArg1] = nml(inputArg1)
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here

normalized_data = (inputArg1 - min(inputArg1))/(max(inputArg1)-min(inputArg1));

outputArg1 = normalized_data;
end

