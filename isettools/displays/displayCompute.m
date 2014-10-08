function [outImage, display] = displayCompute(display, I)
% Computes the upsampled subpixel level image to use in creating a scene
%
%    [outImage,display] = displayCompute(display, I, varargin)
%
%  Inputs:
%    display  - could be either display name or display structure, see 
%               displayCreate for detail
%    I        - input image, should be M*N*k matrix. k should be equal to
%               the number of primaries of display
%
%  Output:
%    outImage - upsampled image, should be in Ms * Ns * k matrix. Default
%               value for upscaling factor s is equal to size(d.psfs, 1)
%
% Examples:
%    display  = displayCreate('LCD-Apple');
%    outImage = displayCompute(display, ones(32));
%    vcNewGraphWin; imagescRGB(outImage);
%
%    I = 0.5*(sin(2*pi*(1:32)/32)+1); I = repmat(I,32,1);
%    outImage = displayCompute('LCD-Apple', I);
%    vcNewGraphWin; imagescRGB(outImage);
%
%    nPixSamples = 10;
%    outImage = displayCompute('LCD-Apple', ones(32), nPixSamples);
%    vcNewGraphWin; imagescRGB(outImage);
%
%  (HJ) April, 2014

%% Init
%  check inputs and init parameters
if notDefined('display'), error('display required'); end
if notDefined('I'), error('Input image required'); end

if ischar(display), display = displayCreate(display); end
if ischar(I), I = im2double(imread(I)); else I = double(I); end


%% Upsampling
nPrimary = displayGet(display, 'n primaries');

psfs = displayGet(display, 'psfs');
if isempty(psfs), error('psf not defined for display'); end
% vcNewGraphWin([],'tall');
% for ii=1:3, subplot(3,1,ii), mesh(psfs(:,:,ii)); end

% If no upsampling, then s is the size of the psf
s = displayGet(display, 'over sample');

% check psfs values to be no less than 0
assert(min(psfs(:)) >= 0, 'psfs values should be non-negative');

% If a single matrix, assume it is gray scale
if ismatrix(I), I = repmat(I, [1 1 nPrimary]); end

% Expand the image so there are s samples within each of the pixels,
% allowing a representation of the psf.
[M, N, ~] = size(I);
pixelPerPSFs = displayGet(display, 'pixels per psfs');
hRender = displayGet(display, 'render function');

if ~isempty(hRender)
    outImage = hRender(I);
else
    outImage = imresize(I, s, 'nearest');
end

% check the size of outImage
assert(size(outImage, 1) == M*s && ...
       size(outImage, 2) == N*s, 'bad outImage size');

% 
outImage = outImage .* repmat(psfs, [M/pixelPerPSFs N/pixelPerPSFs 1]);

end
%% END