/*
 * Photoshop.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class PhotoshopApplication, PhotoshopDocument, PhotoshopBatchOptions, PhotoshopChangeModeOptions, PhotoshopBitmapModeOptions, PhotoshopChannel, PhotoshopColorSampler, PhotoshopContactSheetOptions, PhotoshopCountItem, PhotoshopFont, PhotoshopGalleryBannerOptions, PhotoshopGalleryColorOptions, PhotoshopGalleryImagesOptions, PhotoshopGalleryOptions, PhotoshopGallerySecurityOptions, PhotoshopGalleryThumbnailOptions, PhotoshopHistoryState, PhotoshopIndexedModeOptions, PhotoshopInfoObject, PhotoshopLayer, PhotoshopArtLayer, PhotoshopLayerComp, PhotoshopLayerSet, PhotoshopMeasurementScale, PhotoshopPicturePackageOptions, PhotoshopPresentationOptions, PhotoshopSelectionObject, PhotoshopSettingsObject, PhotoshopTextObject, PhotoshopXMPMetadata, PhotoshopOpenOptions, PhotoshopCameraRAWOpenOptions, PhotoshopDICOMOpenOptions, PhotoshopEPSOpenOptions, PhotoshopPDFOpenOptions, PhotoshopPhotoCDOpenOptions, PhotoshopRawFormatOpenOptions, PhotoshopSaveOptions, PhotoshopBMPSaveOptions, PhotoshopEPSSaveOptions, PhotoshopGIFSaveOptions, PhotoshopJPEGSaveOptions, PhotoshopPDFSaveOptions, PhotoshopPhotoshopDCS10SaveOptions, PhotoshopPhotoshopDCS20SaveOptions, PhotoshopPhotoshopSaveOptions, PhotoshopPICTFileSaveOptions, PhotoshopPICTResourceSaveOptions, PhotoshopPixarSaveOptions, PhotoshopPNGSaveOptions, PhotoshopRawSaveOptions, PhotoshopSGIRGBSaveOptions, PhotoshopTargaSaveOptions, PhotoshopTIFFSaveOptions, PhotoshopExportOptions, PhotoshopIllustratorPathsExportOptions, PhotoshopSaveForWebExportOptions, PhotoshopFilterOptions, PhotoshopAddNoise, PhotoshopAverage, PhotoshopBlur, PhotoshopBlurMore, PhotoshopClouds, PhotoshopCustomFilter, PhotoshopDeinterlace, PhotoshopDespeckle, PhotoshopDifferenceClouds, PhotoshopDiffuseGlow, PhotoshopDisplaceFilter, PhotoshopDustAndScratches, PhotoshopGaussianBlur, PhotoshopGlassFilter, PhotoshopHighPass, PhotoshopLensBlur, PhotoshopLensFlare, PhotoshopMaximumFilter, PhotoshopMedianNoise, PhotoshopMinimumFilter, PhotoshopMotionBlur, PhotoshopNTSCColors, PhotoshopOceanRipple, PhotoshopOffsetFilter, PhotoshopPinch, PhotoshopPolarCoordinates, PhotoshopRadialBlur, PhotoshopRipple, PhotoshopSharpen, PhotoshopSharpenEdges, PhotoshopSharpenMore, PhotoshopShear, PhotoshopSmartBlur, PhotoshopSpherize, PhotoshopTextureFill, PhotoshopTwirl, PhotoshopUnsharpMask, PhotoshopWaveFilter, PhotoshopZigzag, PhotoshopAdjustmentOptions, PhotoshopAutomaticContrast, PhotoshopAutomaticLevels, PhotoshopBrightnessAndContrast, PhotoshopColorBalance, PhotoshopCurves, PhotoshopDesaturate, PhotoshopEqualize, PhotoshopInversion, PhotoshopLevelsAdjustment, PhotoshopMixChannels, PhotoshopPhotoFilter, PhotoshopPosterize, PhotoshopSelectiveColor, PhotoshopShadowHighlight, PhotoshopThresholdAdjustment, PhotoshopColorValue, PhotoshopCMYKColor, PhotoshopGrayColor, PhotoshopHSBColor, PhotoshopLabColor, PhotoshopNoColor, PhotoshopRGBColor, PhotoshopRGBHexColor, PhotoshopPathItem, PhotoshopPathPoint, PhotoshopPathPointInfo, PhotoshopSubPathInfo, PhotoshopSubPathItem, PhotoshopNotifier, PhotoshopMillimeters, PhotoshopPoints, PhotoshopPicas, PhotoshopTraditionalPoints, PhotoshopTraditionalPicas, PhotoshopCiceros, PhotoshopPercent, PhotoshopPixels, PhotoshopRealOrLengthUnit, PhotoshopRealOrLengthOrPixelUnit, PhotoshopRealOrLengthPixelOrPercentUnit;

enum PhotoshopDbex {
	PhotoshopDbexNeverShowDebugger = 'hnsd' /* never show debugger */,
	PhotoshopDbexShowOnError = 'hdoe' /* show on error */,
	PhotoshopDbexShowBeforeRunning = 'hbr ' /* show before running */
};
typedef enum PhotoshopDbex PhotoshopDbex;

enum PhotoshopE815 {
	PhotoshopE815Eight = 'Eigt',
	PhotoshopE815One = 'One ',
	PhotoshopE815Sixteen = 'STen',
	PhotoshopE815ThirtyTwo = 'Tty2'
};
typedef enum PhotoshopE815 PhotoshopE815;

enum PhotoshopOpAs {
	PhotoshopOpAsAliasPIX = 'e025',
	PhotoshopOpAsBMP = 'e002',
	PhotoshopOpAsCameraRAW = 'e032',
	PhotoshopOpAsCompuServeGIF = 'e003',
	PhotoshopOpAsDICOM = 'e033',
	PhotoshopOpAsElectricImage = 'e026',
	PhotoshopOpAsEPS = 'e022',
	PhotoshopOpAsEPSPICTPreview = 'e023',
	PhotoshopOpAsEPSTIFFPreview = 'e024',
	PhotoshopOpAsFilmstrip = 'e005',
	PhotoshopOpAsJPEG = 'e006',
	PhotoshopOpAsPCX = 'e007',
	PhotoshopOpAsPDF = 'e021',
	PhotoshopOpAsPhotoCD = 'e009',
	PhotoshopOpAsPhotoshopDCS10 = 'e018',
	PhotoshopOpAsPhotoshopDCS20 = 'e019',
	PhotoshopOpAsPhotoshopEPS = 'e004',
	PhotoshopOpAsPhotoshopFormat = 'e000',
	PhotoshopOpAsPhotoshopPDF = 'e008',
	PhotoshopOpAsPICTFile = 'e010',
	PhotoshopOpAsPICTResource = 'e011',
	PhotoshopOpAsPixar = 'e012',
	PhotoshopOpAsPNG = 'e013',
	PhotoshopOpAsPortableBitmap = 'e027',
	PhotoshopOpAsRaw = 'e014',
	PhotoshopOpAsScitexCT = 'e015',
	PhotoshopOpAsSGIRGB = 'e029',
	PhotoshopOpAsSoftImage = 'e030',
	PhotoshopOpAsTarga = 'e016',
	PhotoshopOpAsTIFF = 'e017',
	PhotoshopOpAsWavefrontRLA = 'e028',
	PhotoshopOpAsWirelessBitmap = 'e031'
};
typedef enum PhotoshopOpAs PhotoshopOpAs;

enum PhotoshopSvFm {
	PhotoshopSvFmAliasPIX = 'e025',
	PhotoshopSvFmBMP = 'e002',
	PhotoshopSvFmCompuServeGIF = 'e003',
	PhotoshopSvFmElectricImage = 'e026',
	PhotoshopSvFmJPEG = 'e006',
	PhotoshopSvFmPCX = 'e007',
	PhotoshopSvFmPhotoshopDCS10 = 'e018',
	PhotoshopSvFmPhotoshopDCS20 = 'e019',
	PhotoshopSvFmPhotoshopEPS = 'e004',
	PhotoshopSvFmPhotoshopFormat = 'e000',
	PhotoshopSvFmPhotoshopPDF = 'e008',
	PhotoshopSvFmPICTFile = 'e010',
	PhotoshopSvFmPICTResource = 'e011',
	PhotoshopSvFmPixar = 'e012',
	PhotoshopSvFmPNG = 'e013',
	PhotoshopSvFmPortableBitmap = 'e027',
	PhotoshopSvFmRaw = 'e014',
	PhotoshopSvFmScitexCT = 'e015',
	PhotoshopSvFmSGIRGB = 'e029',
	PhotoshopSvFmSoftImage = 'e030',
	PhotoshopSvFmTarga = 'e016',
	PhotoshopSvFmTIFF = 'e017',
	PhotoshopSvFmWavefrontRLA = 'e028',
	PhotoshopSvFmWirelessBitmap = 'e031'
};
typedef enum PhotoshopSvFm PhotoshopSvFm;

enum PhotoshopSavo {
	PhotoshopSavoAsk = 'ask ',
	PhotoshopSavoNo = 'no  ',
	PhotoshopSavoYes = 'yes '
};
typedef enum PhotoshopSavo PhotoshopSavo;

enum PhotoshopE050 {
	PhotoshopE050Always = 'e051',
	PhotoshopE050ErrorDialogs = 'e052',
	PhotoshopE050Never = 'Nevr'
};
typedef enum PhotoshopE050 PhotoshopE050;

enum PhotoshopE080 {
	PhotoshopE080Bitmap = 'e085',
	PhotoshopE080CMYK = 'e083',
	PhotoshopE080Duotone = 'e088',
	PhotoshopE080Grayscale = 'e081',
	PhotoshopE080IndexedColor = 'e086',
	PhotoshopE080Lab = 'e084',
	PhotoshopE080Multichannel = 'e087',
	PhotoshopE080RGB = 'e082'
};
typedef enum PhotoshopE080 PhotoshopE080;

enum PhotoshopE089 {
	PhotoshopE089Bitmap = 'e085',
	PhotoshopE089CMYK = 'e083',
	PhotoshopE089Grayscale = 'e081',
	PhotoshopE089IndexedColor = 'e086',
	PhotoshopE089Lab = 'e084',
	PhotoshopE089Multichannel = 'e087',
	PhotoshopE089RGB = 'e082'
};
typedef enum PhotoshopE089 PhotoshopE089;

enum PhotoshopE090 {
	PhotoshopE090Custom = 'e092',
	PhotoshopE090None = 'DNne',
	PhotoshopE090Working = 'e091'
};
typedef enum PhotoshopE090 PhotoshopE090;

enum PhotoshopE110 {
	PhotoshopE110Transparent = 'e113',
	PhotoshopE110UseBackgroundColor = 'e112',
	PhotoshopE110White = 'e111'
};
typedef enum PhotoshopE110 PhotoshopE110;

enum PhotoshopE100 {
	PhotoshopE100Four = 'Four',
	PhotoshopE100High = 'e107',
	PhotoshopE100Low = 'e101',
	PhotoshopE100None = 'DNne',
	PhotoshopE100Normal = 'Nrml',
	PhotoshopE100Seven = 'e106',
	PhotoshopE100Six = 'e105',
	PhotoshopE100Three = 'e103',
	PhotoshopE100Two = 'Two '
};
typedef enum PhotoshopE100 PhotoshopE100;

enum PhotoshopDori {
	PhotoshopDoriLandscape = 'e121',
	PhotoshopDoriPortrait = 'e122'
};
typedef enum PhotoshopDori PhotoshopDori;

enum PhotoshopE130 {
	PhotoshopE130AbsoluteColorimetric = 'e134',
	PhotoshopE130Perceptual = 'e131',
	PhotoshopE130RelativeColorimetric = 'e133',
	PhotoshopE130SaturationIntent = 'e132'
};
typedef enum PhotoshopE130 PhotoshopE130;

enum PhotoshopE140 {
	PhotoshopE140Horizontal = 'e141',
	PhotoshopE140Vertical = 'e142'
};
typedef enum PhotoshopE140 PhotoshopE140;

enum PhotoshopE150 {
	PhotoshopE150AllCaches = 'e154',
	PhotoshopE150ClipboardCache = 'e153',
	PhotoshopE150HistoryCaches = 'e152',
	PhotoshopE150UndoCaches = 'e151'
};
typedef enum PhotoshopE150 PhotoshopE150;

enum PhotoshopE160 {
	PhotoshopE160BottomCenter = 'e168',
	PhotoshopE160BottomLeft = 'e167',
	PhotoshopE160BottomRight = 'e169',
	PhotoshopE160MiddleCenter = 'e165',
	PhotoshopE160MiddleLeft = 'e164',
	PhotoshopE160MiddleRight = 'e166',
	PhotoshopE160TopCenter = 'e162',
	PhotoshopE160TopLeft = 'e161',
	PhotoshopE160TopRight = 'e163'
};
typedef enum PhotoshopE160 PhotoshopE160;

enum PhotoshopE175 {
	PhotoshopE175Automatic = 'e183',
	PhotoshopE175Bicubic = 'e178',
	PhotoshopE175BicubicAutomatic = 'e182',
	PhotoshopE175BicubicSharper = 'e179',
	PhotoshopE175BicubicSmoother = 'e180',
	PhotoshopE175Bilinear = 'e177',
	PhotoshopE175ClosestNeighbor = 'e176',
	PhotoshopE175None = 'DNne',
	PhotoshopE175PreserveDetails = 'e184'
};
typedef enum PhotoshopE175 PhotoshopE175;

enum PhotoshopE191 {
	PhotoshopE191OS2 = 'e192',
	PhotoshopE191Windows = 'e193'
};
typedef enum PhotoshopE191 PhotoshopE191;

enum PhotoshopE200 {
	PhotoshopE200BlackAndWhite = 'e201',
	PhotoshopE200None = 'DNne',
	PhotoshopE200Primaries = 'e202',
	PhotoshopE200Web = 'e203'
};
typedef enum PhotoshopE200 PhotoshopE200;

enum PhotoshopE210 {
	PhotoshopE210Exact = 'e211',
	PhotoshopE210LocalAdaptive = 'e217',
	PhotoshopE210LocalPerceptual = 'e215',
	PhotoshopE210LocalSelective = 'e216',
	PhotoshopE210MacOSSystem = 'e212',
	PhotoshopE210MasterAdaptive = 'e220',
	PhotoshopE210MasterPerceptual = 'e218',
	PhotoshopE210MasterSelective = 'e219',
	PhotoshopE210Previous = 'e221',
	PhotoshopE210Uniform = 'e214',
	PhotoshopE210Web = 'e203',
	PhotoshopE210WindowsSystem = 'e213'
};
typedef enum PhotoshopE210 PhotoshopE210;

enum PhotoshopE230 {
	PhotoshopE230Diffusion = 'e231',
	PhotoshopE230Noise = 'e233',
	PhotoshopE230None = 'DNne',
	PhotoshopE230Pattern = 'e232'
};
typedef enum PhotoshopE230 PhotoshopE230;

enum PhotoshopE250 {
	PhotoshopE250EightBitMacOS = 'e254',
	PhotoshopE250EightBitTIFF = 'e252',
	PhotoshopE250JPEGMacOS = 'e255',
	PhotoshopE250MonochromeMacOS = 'e253',
	PhotoshopE250MonochromeTIFF = 'e251',
	PhotoshopE250None = 'DNne'
};
typedef enum PhotoshopE250 PhotoshopE250;

enum PhotoshopE260 {
	PhotoshopE260ASCII = 'e073',
	PhotoshopE260Binary = 'e071',
	PhotoshopE260HighQualityJPEG = 'e263',
	PhotoshopE260LowQualityJPEG = 'e261',
	PhotoshopE260MaximumQualityJPEG = 'e264',
	PhotoshopE260MediumQualityJPEG = 'e262'
};
typedef enum PhotoshopE260 PhotoshopE260;

enum PhotoshopE270 {
	PhotoshopE270Optimized = 'e272',
	PhotoshopE270Progressive = 'e273',
	PhotoshopE270Standard = 'Stdr'
};
typedef enum PhotoshopE270 PhotoshopE270;

enum PhotoshopE280 {
	PhotoshopE280JPEG = 'e006',
	PhotoshopE280JPEG2000High = 'JPG5',
	PhotoshopE280JPEG2000Lossless = 'JPGA',
	PhotoshopE280JPEG2000Low = 'JPG9',
	PhotoshopE280JPEG2000Med = 'JPG7',
	PhotoshopE280JPEG2000MedHigh = 'JPG6',
	PhotoshopE280JPEG2000MedLow = 'JPG8',
	PhotoshopE280JPEGHigh = 'JPG0',
	PhotoshopE280JPEGLow = 'JPG4',
	PhotoshopE280JPEGMed = 'JPG2',
	PhotoshopE280JPEGMedHigh = 'JPG1',
	PhotoshopE280JPEGMedLow = 'JPG3',
	PhotoshopE280None = 'DNne',
	PhotoshopE280ZIP = 'e281',
	PhotoshopE280ZIP4 = 'e282'
};
typedef enum PhotoshopE280 PhotoshopE280;

enum PhotoshopPD01 {
	PhotoshopPD01None = 'DNne',
	PhotoshopPD01PDFX1a2001Standard = 'PD02',
	PhotoshopPD01PDFX1a2003Standard = 'PD03',
	PhotoshopPD01PDFX32002Standard = 'PD04',
	PhotoshopPD01PDFX32003Standard = 'PD05',
	PhotoshopPD01PDFX42008Standard = 'PD33'
};
typedef enum PhotoshopPD01 PhotoshopPD01;

enum PhotoshopPD08 {
	PhotoshopPD08PDF13 = 'PD09',
	PhotoshopPD08PDF14 = 'PD10',
	PhotoshopPD08PDF15 = 'PD11',
	PhotoshopPD08PDF16 = 'PD12',
	PhotoshopPD08PDF17 = 'PD32'
};
typedef enum PhotoshopPD08 PhotoshopPD08;

enum PhotoshopPD16 {
	PhotoshopPD16None = 'DNne',
	PhotoshopPD16PDFAverage = 'PD17',
	PhotoshopPD16PDFBicubic = 'PD19',
	PhotoshopPD16PDFSubsample = 'PD18'
};
typedef enum PhotoshopPD16 PhotoshopPD16;

enum PhotoshopE290 {
	PhotoshopE290HighQualityJPEG = 'e263',
	PhotoshopE290LowQualityJPEG = 'e261',
	PhotoshopE290MaximumQualityJPEG = 'e264',
	PhotoshopE290MediumQualityJPEG = 'e262',
	PhotoshopE290None = 'DNne'
};
typedef enum PhotoshopE290 PhotoshopE290;

enum PhotoshopE300 {
	PhotoshopE300LowercaseExtension = 'e301',
	PhotoshopE300NoExtension = 'e303',
	PhotoshopE300UppercaseExtension = 'e302'
};
typedef enum PhotoshopE300 PhotoshopE300;

enum PhotoshopE320 {
	PhotoshopE320JPEG = 'e006',
	PhotoshopE320LZW = 'e321',
	PhotoshopE320None = 'DNne',
	PhotoshopE320ZIP = 'e281'
};
typedef enum PhotoshopE320 PhotoshopE320;

enum PhotoshopE325 {
	PhotoshopE325RLE = 'e326',
	PhotoshopE325ZIP = 'e281'
};
typedef enum PhotoshopE325 PhotoshopE325;

enum PhotoshopE330 {
	PhotoshopE330IBMPC = 'e331',
	PhotoshopE330MacOS = 'e332'
};
typedef enum PhotoshopE330 PhotoshopE330;

enum PhotoshopE340 {
	PhotoshopE340ColorComposite = 'e343',
	PhotoshopE340GrayscaleComposite = 'e342',
	PhotoshopE340NoCompositePostScript = 'e341'
};
typedef enum PhotoshopE340 PhotoshopE340;

enum PhotoshopE350 {
	PhotoshopE350BottomRightPixel = 'e353',
	PhotoshopE350TopLeftPixel = 'e352',
	PhotoshopE350TransparentPixels = 'e351'
};
typedef enum PhotoshopE350 PhotoshopE350;

enum PhotoshopE360 {
	PhotoshopE360AdobeColorPicker = 'e361',
	PhotoshopE360AppleColorPicker = 'e362',
	PhotoshopE360PlugInColorPicker = 'e364',
	PhotoshopE360WindowsColorPicker = 'e363'
};
typedef enum PhotoshopE360 PhotoshopE360;

enum PhotoshopE390 {
	PhotoshopE390AllTools = 'e392',
	PhotoshopE390AllWarnings = 'e391',
	PhotoshopE390Everything = 'e393'
};
typedef enum PhotoshopE390 PhotoshopE390;

enum PhotoshopE400 {
	PhotoshopE400Ask = 'ask ',
	PhotoshopE400No = 'no  ',
	PhotoshopE400Yes = 'yes '
};
typedef enum PhotoshopE400 PhotoshopE400;

enum PhotoshopE410 {
	PhotoshopE410BrushSize = 'e413',
	PhotoshopE410Precise = 'e412',
	PhotoshopE410Standard = 'Stdr'
};
typedef enum PhotoshopE410 PhotoshopE410;

enum PhotoshopE415 {
	PhotoshopE415Precise = 'e412',
	PhotoshopE415Standard = 'Stdr'
};
typedef enum PhotoshopE415 PhotoshopE415;

enum PhotoshopE420 {
	PhotoshopE420Large = 'Lrge',
	PhotoshopE420Medium = 'Mdum',
	PhotoshopE420None = 'DNne',
	PhotoshopE420Small = 'Smll'
};
typedef enum PhotoshopE420 PhotoshopE420;

enum PhotoshopE440 {
	PhotoshopE440CmUnits = 'Cntm',
	PhotoshopE440InchUnits = 'Inhs',
	PhotoshopE440MmUnits = 'MlMt',
	PhotoshopE440PercentUnits = 'Pcnt',
	PhotoshopE440PicaUnits = 'Pcas',
	PhotoshopE440PixelUnits = 'Pxls',
	PhotoshopE440PointUnits = 'Pnts'
};
typedef enum PhotoshopE440 PhotoshopE440;

enum PhotoshopE445 {
	PhotoshopE445MmUnits = 'MlMt',
	PhotoshopE445PixelUnits = 'Pxls',
	PhotoshopE445PointUnits = 'Pnts'
};
typedef enum PhotoshopE445 PhotoshopE445;

enum PhotoshopE450 {
	PhotoshopE450PostscriptSize = 'e451',
	PhotoshopE450TraditionalSize = 'e452'
};
typedef enum PhotoshopE450 PhotoshopE450;

enum PhotoshopE460 {
	PhotoshopE460DashedLine = 'e462',
	PhotoshopE460DottedLine = 'e463',
	PhotoshopE460SolidLine = 'e461'
};
typedef enum PhotoshopE460 PhotoshopE460;

enum PhotoshopE464 {
	PhotoshopE464DashedLine = 'e462',
	PhotoshopE464SolidLine = 'e461'
};
typedef enum PhotoshopE464 PhotoshopE464;

enum PhotoshopE470 {
	PhotoshopE470ColorBlend = 'e488',
	PhotoshopE470ColorBurn = 'e481',
	PhotoshopE470ColorDodge = 'e480',
	PhotoshopE470Darken = 'e482',
	PhotoshopE470DarkerColor = 'e497',
	PhotoshopE470Difference = 'e484',
	PhotoshopE470Dissolve = 'e490',
	PhotoshopE470Divide = 'e499',
	PhotoshopE470Exclusion = 'e485',
	PhotoshopE470HardLight = 'e478',
	PhotoshopE470HardMix = 'e495',
	PhotoshopE470HueBlend = 'e486',
	PhotoshopE470Lighten = 'e483',
	PhotoshopE470LighterColor = 'e496',
	PhotoshopE470LinearBurn = 'e491',
	PhotoshopE470LinearDodge = 'e492',
	PhotoshopE470LinearLight = 'e479',
	PhotoshopE470Luminosity = 'e489',
	PhotoshopE470Multiply = 'e472',
	PhotoshopE470Normal = 'Nrml',
	PhotoshopE470Overlay = 'e476',
	PhotoshopE470PassThrough = 'e471',
	PhotoshopE470PinLight = 'e494',
	PhotoshopE470SaturationBlend = 'e487',
	PhotoshopE470Screen = 'e474',
	PhotoshopE470SoftLight = 'e477',
	PhotoshopE470Subtract = 'e498',
	PhotoshopE470VividLight = 'e493'
};
typedef enum PhotoshopE470 PhotoshopE470;

enum PhotoshopE925 {
	PhotoshopE925BehindMode = 'e926',
	PhotoshopE925ClearMode = 'e927',
	PhotoshopE925ColorBlend = 'e488',
	PhotoshopE925ColorBurn = 'e481',
	PhotoshopE925ColorDodge = 'e480',
	PhotoshopE925Darken = 'e482',
	PhotoshopE925Difference = 'e484',
	PhotoshopE925Dissolve = 'e490',
	PhotoshopE925Divide = 'e499',
	PhotoshopE925Exclusion = 'e485',
	PhotoshopE925HardLight = 'e478',
	PhotoshopE925HardMix = 'e495',
	PhotoshopE925HueBlend = 'e486',
	PhotoshopE925Lighten = 'e483',
	PhotoshopE925LinearBurn = 'e491',
	PhotoshopE925LinearDodge = 'e492',
	PhotoshopE925LinearLight = 'e479',
	PhotoshopE925Luminosity = 'e489',
	PhotoshopE925Multiply = 'e472',
	PhotoshopE925Normal = 'Nrml',
	PhotoshopE925Overlay = 'e476',
	PhotoshopE925PinLight = 'e494',
	PhotoshopE925SaturationBlend = 'e487',
	PhotoshopE925Screen = 'e474',
	PhotoshopE925SoftLight = 'e477',
	PhotoshopE925Subtract = 'e498',
	PhotoshopE925VividLight = 'e493'
};
typedef enum PhotoshopE925 PhotoshopE925;

enum PhotoshopE510 {
	PhotoshopE510AllLinkedLayers = 'e516',
	PhotoshopE510EntireLayer = 'e515',
	PhotoshopE510FillContent = 'e513',
	PhotoshopE510LayerClippingPath = 'e514',
	PhotoshopE510Shape = 'e512',
	PhotoshopE510TextContents = 'e511'
};
typedef enum PhotoshopE510 PhotoshopE510;

enum PhotoshopE520 {
	PhotoshopE520Center = 'cent',
	PhotoshopE520CenterJustified = 'JCtr',
	PhotoshopE520FullyJustified = 'JFll',
	PhotoshopE520Left = 'ALft',
	PhotoshopE520LeftJustified = 'JLft',
	PhotoshopE520Right = 'ARgt',
	PhotoshopE520RightJustified = 'JRgt'
};
typedef enum PhotoshopE520 PhotoshopE520;

enum PhotoshopE530 {
	PhotoshopE530Crisp = 'e531',
	PhotoshopE530None = 'DNne',
	PhotoshopE530Sharp = 'e534',
	PhotoshopE530Smoothing = 'e533',
	PhotoshopE530Strong = 'e532'
};
typedef enum PhotoshopE530 PhotoshopE530;

enum PhotoshopE540 {
	PhotoshopE540AllCaps = 'e541',
	PhotoshopE540Normal = 'Nrml',
	PhotoshopE540SmallCaps = 'e542'
};
typedef enum PhotoshopE540 PhotoshopE540;

enum PhotoshopE560 {
	PhotoshopE560BrazilianPortuguese = 'e563',
	PhotoshopE560CanadianFrench = 'e564',
	PhotoshopE560Danish = 'e578',
	PhotoshopE560Dutch = 'e577',
	PhotoshopE560EnglishUK = 'e576',
	PhotoshopE560EnglishUSA = 'e561',
	PhotoshopE560Finnish = 'e565',
	PhotoshopE560French = 'e570',
	PhotoshopE560German = 'e571',
	PhotoshopE560Italian = 'e566',
	PhotoshopE560Norwegian = 'e562',
	PhotoshopE560NynorskNorwegian = 'e567',
	PhotoshopE560OldGerman = 'e568',
	PhotoshopE560Portuguese = 'e572',
	PhotoshopE560Spanish = 'e569',
	PhotoshopE560Swedish = 'e573',
	PhotoshopE560SwissGerman = 'e574'
};
typedef enum PhotoshopE560 PhotoshopE560;

enum PhotoshopE580 {
	PhotoshopE580ParagraphText = 'e582',
	PhotoshopE580PointText = 'e581'
};
typedef enum PhotoshopE580 PhotoshopE580;

enum PhotoshopE600 {
	PhotoshopE600Arc = 'e601',
	PhotoshopE600ArcLower = 'e602',
	PhotoshopE600ArcUpper = 'e603',
	PhotoshopE600Arch = 'e604',
	PhotoshopE600Bulge = 'e605',
	PhotoshopE600Fish = 'e610',
	PhotoshopE600FishEye = 'e613',
	PhotoshopE600Flag = 'e608',
	PhotoshopE600Inflate = 'e614',
	PhotoshopE600None = 'DNne',
	PhotoshopE600Rise = 'e612',
	PhotoshopE600ShellLower = 'e606',
	PhotoshopE600ShellUpper = 'e607',
	PhotoshopE600Squeeze = 'e615',
	PhotoshopE600Twist = 'e616',
	PhotoshopE600Wave = 'e609'
};
typedef enum PhotoshopE600 PhotoshopE600;

enum PhotoshopE590 {
	PhotoshopE590AdobeEveryLine = 'e592',
	PhotoshopE590AdobeSingleLine = 'e591'
};
typedef enum PhotoshopE590 PhotoshopE590;

enum PhotoshopE980 {
	PhotoshopE980Manual = 'e981',
	PhotoshopE980Metrics = 'e982',
	PhotoshopE980Optical = 'e983'
};
typedef enum PhotoshopE980 PhotoshopE980;

enum PhotoshopE990 {
	PhotoshopE990Off = 'e991',
	PhotoshopE990StrikeBox = 'e993',
	PhotoshopE990StrikeHeight = 'e992'
};
typedef enum PhotoshopE990 PhotoshopE990;

enum PhotoshopEA00 {
	PhotoshopEA00Left = 'ALft',
	PhotoshopEA00Off = 'e991',
	PhotoshopEA00Right = 'ARgt'
};
typedef enum PhotoshopEA00 PhotoshopEA00;

enum PhotoshopE630 {
	PhotoshopE630Diminished = 'e633',
	PhotoshopE630Extended = 'e632',
	PhotoshopE630Intersected = 'e634',
	PhotoshopE630Replaced = 'e631'
};
typedef enum PhotoshopE630 PhotoshopE630;

enum PhotoshopE640 {
	PhotoshopE640IllustratorPaths = 'e641',
	PhotoshopE640SaveForWeb = 'e643'
};
typedef enum PhotoshopE640 PhotoshopE640;

enum PhotoshopE650 {
	PhotoshopE650AllPaths = 'e652',
	PhotoshopE650DocumentBounds = 'e651',
	PhotoshopE650NamedPath = 'e653'
};
typedef enum PhotoshopE650 PhotoshopE650;

enum PhotoshopE660 {
	PhotoshopE660ComponentChannel = 'e661',
	PhotoshopE660MaskedAreaChannel = 'e662',
	PhotoshopE660SelectedAreaChannel = 'e663',
	PhotoshopE660SpotColorChannel = 'e664'
};
typedef enum PhotoshopE660 PhotoshopE660;

enum PhotoshopE850 {
	PhotoshopE850CopyrightedWork = 'e851',
	PhotoshopE850PublicDomain = 'e852',
	PhotoshopE850Unmarked = 'e853'
};
typedef enum PhotoshopE850 PhotoshopE850;

enum PhotoshopE860 {
	PhotoshopE860CustomPattern = 'e865',
	PhotoshopE860DiffusionDither = 'e863',
	PhotoshopE860HalftoneScreenConversion = 'e864',
	PhotoshopE860MiddleThreshold = 'e861',
	PhotoshopE860PatternDither = 'e862'
};
typedef enum PhotoshopE860 PhotoshopE860;

enum PhotoshopE870 {
	PhotoshopE870HalftoneCross = 'e875',
	PhotoshopE870HalftoneDiamond = 'e872',
	PhotoshopE870HalftoneEllipse = 'e873',
	PhotoshopE870HalftoneLine = 'e876',
	PhotoshopE870HalftoneRound = 'e871',
	PhotoshopE870HalftoneSquare = 'e874'
};
typedef enum PhotoshopE870 PhotoshopE870;

enum PhotoshopE880 {
	PhotoshopE880BackgroundColorMatte = 'e882',
	PhotoshopE880BlackMatte = 'e884',
	PhotoshopE880ForegroundColorMatte = 'e881',
	PhotoshopE880NetscapeGray = 'e886',
	PhotoshopE880None = 'DNne',
	PhotoshopE880SemiGray = 'e885',
	PhotoshopE880WhiteMatte = 'e883'
};
typedef enum PhotoshopE880 PhotoshopE880;

enum PhotoshopE890 {
	PhotoshopE890Absolute = 'Ablt',
	PhotoshopE890Relative = 'RlTv'
};
typedef enum PhotoshopE890 PhotoshopE890;

enum PhotoshopE900 {
	PhotoshopE900CMYK = 'e083',
	PhotoshopE900Grayscale = 'e081',
	PhotoshopE900Lab = 'e084',
	PhotoshopE900RGB = 'e082'
};
typedef enum PhotoshopE900 PhotoshopE900;

enum PhotoshopE905 {
	PhotoshopE905Bitmap = 'e085',
	PhotoshopE905CMYK = 'e083',
	PhotoshopE905Grayscale = 'e081',
	PhotoshopE905Lab = 'e084',
	PhotoshopE905RGB = 'e082'
};
typedef enum PhotoshopE905 PhotoshopE905;

enum PhotoshopE910 {
	PhotoshopE910Lab16 = 'e914',
	PhotoshopE910Lab8 = 'e913',
	PhotoshopE910RGB16 = 'e912',
	PhotoshopE910RGB8 = 'e911'
};
typedef enum PhotoshopE910 PhotoshopE910;

enum PhotoshopE920 {
	PhotoshopE920Center = 'cent',
	PhotoshopE920Inside = 'e921',
	PhotoshopE920Outside = 'e922'
};
typedef enum PhotoshopE920 PhotoshopE920;

enum PhotoshopE930 {
	PhotoshopE930CMYK = 'e083',
	PhotoshopE930Grayscale = 'e081',
	PhotoshopE930HSB = 'e932',
	PhotoshopE930Lab = 'e084',
	PhotoshopE930RGB = 'e082',
	PhotoshopE930RGBHex = 'e934'
};
typedef enum PhotoshopE930 PhotoshopE930;

enum PhotoshopE940 {
	PhotoshopE940BeforeRunning = 'a942',
	PhotoshopE940Never = 'Nevr',
	PhotoshopE940OnRuntimeError = 'e941'
};
typedef enum PhotoshopE940 PhotoshopE940;

enum PhotoshopE945 {
	PhotoshopE945DocumentSpace = 'e946',
	PhotoshopE945ProofSpace = 'a947'
};
typedef enum PhotoshopE945 PhotoshopE945;

enum PhotoshopE950 {
	PhotoshopE950BlackAndWhiteLayer = 'e972',
	PhotoshopE950BrightnessContrastLayer = 'e957',
	PhotoshopE950ChannelMixerLayer = 'e960',
	PhotoshopE950ColorBalanceLayer = 'e965',
	PhotoshopE950CurvesLayer = 'e956',
	PhotoshopE950ExposureLayer = 'e969',
	PhotoshopE950GradientFillLayer = 'e953',
	PhotoshopE950GradientMapLayer = 'e961',
	PhotoshopE950HueSaturationLayer = 'e958',
	PhotoshopE950InversionLayer = 'e962',
	PhotoshopE950LevelsLayer = 'e955',
	PhotoshopE950Normal = 'Nrml',
	PhotoshopE950PatternFillLayer = 'e954',
	PhotoshopE950PhotoFilterLayer = 'e968',
	PhotoshopE950PosterizeLayer = 'e964',
	PhotoshopE950SelectiveColorLayer = 'e959',
	PhotoshopE950SmartObjectLayer = 'e967',
	PhotoshopE950SolidFillLayer = 'e952',
	PhotoshopE950TextLayer = 'e966',
	PhotoshopE950ThreeDLayer = 'e970',
	PhotoshopE950ThresholdLayer = 'e963',
	PhotoshopE950VibranceLayer = 'e973',
	PhotoshopE950VideoLayer = 'e971'
};
typedef enum PhotoshopE950 PhotoshopE950;

enum PhotoshopPDFb {
	PhotoshopPDFbBlindsHorizontal = 'PDFc',
	PhotoshopPDFbBlindsVertical = 'PDFd',
	PhotoshopPDFbBoxIn = 'PDFe',
	PhotoshopPDFbBoxOut = 'PDFf',
	PhotoshopPDFbDissolve = 'e490',
	PhotoshopPDFbGlitterDown = 'PDFg',
	PhotoshopPDFbGlitterRight = 'PDFh',
	PhotoshopPDFbGlitterRightDown = 'PDFi',
	PhotoshopPDFbNone = 'DNne',
	PhotoshopPDFbRandom = 'PDFj',
	PhotoshopPDFbSplitHorizontalIn = 'PDFk',
	PhotoshopPDFbSplitHorizontalOut = 'PDFl',
	PhotoshopPDFbSplitVerticalIn = 'PDFm',
	PhotoshopPDFbSplitVerticalOut = 'PDFn',
	PhotoshopPDFbWipeDown = 'PDFo',
	PhotoshopPDFbWipeLeft = 'PDFp',
	PhotoshopPDFbWipeRight = 'PDFq',
	PhotoshopPDFbWipeUp = 'PDFr'
};
typedef enum PhotoshopPDFb PhotoshopPDFb;

enum PhotoshopPGa2 {
	PhotoshopPGa2Arial = 'PG03',
	PhotoshopPGa2CourierNew = 'PG04',
	PhotoshopPGa2Helvetica = 'PG05',
	PhotoshopPGa2TimesNewRoman = 'PG07'
};
typedef enum PhotoshopPGa2 PhotoshopPGa2;

enum PhotoshopPGa3 {
	PhotoshopPGa3ConstrainBoth = 'PG10',
	PhotoshopPGa3ConstrainHeight = 'PG09',
	PhotoshopPGa3ConstrainWidth = 'PG08'
};
typedef enum PhotoshopPGa3 PhotoshopPGa3;

enum PhotoshopPGa4 {
	PhotoshopPGa4GalleryCustom = 'PG14',
	PhotoshopPGa4GalleryLarge = 'PG13',
	PhotoshopPGa4GalleryMedium = 'PG12',
	PhotoshopPGa4GallerySmall = 'PG11'
};
typedef enum PhotoshopPGa4 PhotoshopPGa4;

enum PhotoshopPGa5 {
	PhotoshopPGa5GalleryCaption = 'PG19',
	PhotoshopPGa5GalleryCopyright = 'PG18',
	PhotoshopPGa5GalleryCredit = 'PG20',
	PhotoshopPGa5GalleryCustomText = 'PG16',
	PhotoshopPGa5GalleryFilename = 'PG17',
	PhotoshopPGa5GalleryNone = 'PG15',
	PhotoshopPGa5GalleryTitle = 'PG21'
};
typedef enum PhotoshopPGa5 PhotoshopPGa5;

enum PhotoshopPP09 {
	PhotoshopPP09CaptionText = 'PP05',
	PhotoshopPP09CopyrightText = 'PP04',
	PhotoshopPP09CreditText = 'PP06',
	PhotoshopPP09FilenameText = 'PP03',
	PhotoshopPP09NoText = 'PP02',
	PhotoshopPP09OriginText = 'PP07',
	PhotoshopPP09UserText = 'PP08'
};
typedef enum PhotoshopPP09 PhotoshopPP09;

enum PhotoshopPGa6 {
	PhotoshopPGa6GallerySecurityBlack = 'PG22',
	PhotoshopPGa6GallerySecurityCustom = 'PG24',
	PhotoshopPGa6GallerySecurityWhite = 'PG23'
};
typedef enum PhotoshopPGa6 PhotoshopPGa6;

enum PhotoshopPGa7 {
	PhotoshopPGa7GalleryCentered = 'PG25',
	PhotoshopPGa7GalleryLowerLeft = 'PG27',
	PhotoshopPGa7GalleryLowerRight = 'PG29',
	PhotoshopPGa7GalleryUpperLeft = 'PG26',
	PhotoshopPGa7GalleryUpperRight = 'PG28'
};
typedef enum PhotoshopPGa7 PhotoshopPGa7;

enum PhotoshopPGa8 {
	PhotoshopPGa8ClockWise45 = 'PG31',
	PhotoshopPGa8ClockWise90 = 'PG32',
	PhotoshopPGa8CounterClockWise45 = 'PG33',
	PhotoshopPGa8CounterClockWise90 = 'PG34',
	PhotoshopPGa8Zero = 'PG30'
};
typedef enum PhotoshopPGa8 PhotoshopPGa8;

enum PhotoshopMX00 {
	PhotoshopMX00Always = 'e051',
	PhotoshopMX00Ask = 'ask ',
	PhotoshopMX00Never = 'Nevr'
};
typedef enum PhotoshopMX00 PhotoshopMX00;

enum PhotoshopPr49 {
	PhotoshopPr49Both = 'Pr52',
	PhotoshopPr49LogFile = 'Pr51',
	PhotoshopPr49Metadata = 'Pr50'
};
typedef enum PhotoshopPr49 PhotoshopPr49;

enum PhotoshopPr53 {
	PhotoshopPr53Concise = 'Pr55',
	PhotoshopPr53Detailed = 'Pr56',
	PhotoshopPr53Sessiononly = 'Pr54'
};
typedef enum PhotoshopPr53 PhotoshopPr53;

enum PhotoshopBT14 {
	PhotoshopBT14Folder = 'BT16',
	PhotoshopBT14None = 'DNne',
	PhotoshopBT14SaveAndClose = 'BT15'
};
typedef enum PhotoshopBT14 PhotoshopBT14;

enum PhotoshopBT17 {
	PhotoshopBT17Ddmm = 'BT33',
	PhotoshopBT17Ddmmyy = 'BT32',
	PhotoshopBT17DocumentName3 = 'BT20',
	PhotoshopBT17DocumentNameLower = 'BT19',
	PhotoshopBT17DocumentNameMixed = 'BT18',
	PhotoshopBT17ExtensionLower = 'BT34',
	PhotoshopBT17ExtensionUpper = 'BT35',
	PhotoshopBT17Mmdd = 'BT28',
	PhotoshopBT17Mmddyy = 'BT27',
	PhotoshopBT17SerialLetterLower = 'BT25',
	PhotoshopBT17SerialLetterUpper = 'BT26',
	PhotoshopBT17SerialNumberFour = 'BT24',
	PhotoshopBT17SerialNumberOne = 'BT21',
	PhotoshopBT17SerialNumberThree = 'BT23',
	PhotoshopBT17SerialNumberTwo = 'BT22',
	PhotoshopBT17Yyddmm = 'BT31',
	PhotoshopBT17Yymmdd = 'BT30',
	PhotoshopBT17Yyyymmdd = 'BT29'
};
typedef enum PhotoshopBT17 PhotoshopBT17;

enum PhotoshopLB00 {
	PhotoshopLB00ImageHighlight = 'LB02',
	PhotoshopLB00LayerMask = 'LB01',
	PhotoshopLB00None = 'DNne',
	PhotoshopLB00TransparencyChannel = 'LB17'
};
typedef enum PhotoshopLB00 PhotoshopLB00;

enum PhotoshopLB03 {
	PhotoshopLB03Heptagon = 'LB08',
	PhotoshopLB03Hexagon = 'LB07',
	PhotoshopLB03Octagon = 'LB09',
	PhotoshopLB03Pentagon = 'LB06',
	PhotoshopLB03Square = 'e733',
	PhotoshopLB03Triangle = 'LB04'
};
typedef enum PhotoshopLB03 PhotoshopLB03;

enum PhotoshopCR38 {
	PhotoshopCR38Adaptive = 'CR41',
	PhotoshopCR38BlackWhite = 'CR44',
	PhotoshopCR38CustomReduction = 'CR35',
	PhotoshopCR38Grayscale = 'e081',
	PhotoshopCR38MacintoshColors = 'CR45',
	PhotoshopCR38PerceptualReduction = 'CR39',
	PhotoshopCR38Restrictive = 'CR42',
	PhotoshopCR38Selective = 'CR40',
	PhotoshopCR38WindowsColors = 'CR37'
};
typedef enum PhotoshopCR38 PhotoshopCR38;

enum PhotoshopCR02 {
	PhotoshopCR02CameraDefault = 'CR03',
	PhotoshopCR02CustomSettings = 'CR36',
	PhotoshopCR02SelectedImage = 'CR04'
};
typedef enum PhotoshopCR02 PhotoshopCR02;

enum PhotoshopCR05 {
	PhotoshopCR05AsShot = 'CR06',
	PhotoshopCR05Auto = 'CR07',
	PhotoshopCR05Cloudy = 'CR09',
	PhotoshopCR05CustomCameraSettings = 'CR18',
	PhotoshopCR05Daylight = 'CR08',
	PhotoshopCR05Flash = 'CR13',
	PhotoshopCR05Fluorescent = 'CR12',
	PhotoshopCR05Shade = 'CR10',
	PhotoshopCR05Tungsten = 'CR11'
};
typedef enum PhotoshopCR05 PhotoshopCR05;

enum PhotoshopCR46 {
	PhotoshopCR46AdobeRGB = 'CR47',
	PhotoshopCR46ColorMatchRGB = 'CR48',
	PhotoshopCR46ProPhotoRGB = 'CR49',
	PhotoshopCR46SRGB = 'CR50'
};
typedef enum PhotoshopCR46 PhotoshopCR46;

enum PhotoshopCR34 {
	PhotoshopCR34ExtraLarge = 'e811',
	PhotoshopCR34Large = 'Lrge',
	PhotoshopCR34Maximum = 'Maxi',
	PhotoshopCR34Medium = 'Mdum',
	PhotoshopCR34Minimum = 'Mini',
	PhotoshopCR34Small = 'Smll'
};
typedef enum PhotoshopCR34 PhotoshopCR34;

enum PhotoshopPDFx {
	PhotoshopPDFxActualSize = 'PDFy',
	PhotoshopPDFxFitPage = 'PDFz'
};
typedef enum PhotoshopPDFx PhotoshopPDFx;

enum PhotoshopCrtO {
	PhotoshopCrtOArtBox = 'crt6',
	PhotoshopCrtOBleedBox = 'crt4',
	PhotoshopCrtOBoundingBox = 'crt1',
	PhotoshopCrtOCropBox = 'crt3',
	PhotoshopCrtOMediaBox = 'crt2',
	PhotoshopCrtOTrimBox = 'crt5'
};
typedef enum PhotoshopCrtO PhotoshopCrtO;

enum PhotoshopFP00 {
	PhotoshopFP00ExtraLarge = 'e811',
	PhotoshopFP00None = 'DNne',
	PhotoshopFP00PreviewHuge = 'FP05',
	PhotoshopFP00PreviewLarge = 'FP03',
	PhotoshopFP00PreviewMedium = 'FP02',
	PhotoshopFP00PreviewSmall = 'FP01'
};
typedef enum PhotoshopFP00 PhotoshopFP00;

enum PhotoshopME00 {
	PhotoshopME00MeasureCountTool = 'ME02',
	PhotoshopME00MeasureRulerTool = 'ME03',
	PhotoshopME00MeasureSelection = 'ME01'
};
typedef enum PhotoshopME00 PhotoshopME00;

enum PhotoshopE810 {
	PhotoshopE810ExtraLarge = 'e811',
	PhotoshopE810Large = 'Lrge',
	PhotoshopE810Maximum = 'Maxi',
	PhotoshopE810Medium = 'Mdum',
	PhotoshopE810Minimum = 'Mini',
	PhotoshopE810Small = 'Smll'
};
typedef enum PhotoshopE810 PhotoshopE810;

enum PhotoshopE840 {
	PhotoshopE840Eight = 'Eigt',
	PhotoshopE840Four = 'Four',
	PhotoshopE840Sixteen = 'STen',
	PhotoshopE840ThirtyTwo = 'Tty2',
	PhotoshopE840Two = 'Two '
};
typedef enum PhotoshopE840 PhotoshopE840;

enum PhotoshopE845 {
	PhotoshopE845Sixteen = 'STen',
	PhotoshopE845ThirtyTwo = 'Tty2',
	PhotoshopE845TwentyFour = 'TyFr'
};
typedef enum PhotoshopE845 PhotoshopE845;

enum PhotoshopE820 {
	PhotoshopE820A1R5G5B5 = 'e828',
	PhotoshopE820A4R4G4B4 = 'e831',
	PhotoshopE820A8R8G8B8 = 'e834',
	PhotoshopE820Eight = 'Eigt',
	PhotoshopE820Four = 'Four',
	PhotoshopE820One = 'One ',
	PhotoshopE820R5G6B5 = 'e829',
	PhotoshopE820R8G8B8 = 'e832',
	PhotoshopE820Sixteen = 'STen',
	PhotoshopE820ThirtyTwo = 'Tty2',
	PhotoshopE820TwentyFour = 'TyFr',
	PhotoshopE820X1R5G5B5 = 'e827',
	PhotoshopE820X4R4G4B4 = 'e830',
	PhotoshopE820X8R8G8B8 = 'e833'
};
typedef enum PhotoshopE820 PhotoshopE820;

enum PhotoshopE670 {
	PhotoshopE670Spin = 'e671',
	PhotoshopE670Zoom = 'e672'
};
typedef enum PhotoshopE670 PhotoshopE670;

enum PhotoshopE675 {
	PhotoshopE675Best = 'e678',
	PhotoshopE675Draft = 'e676',
	PhotoshopE675Good = 'e677'
};
typedef enum PhotoshopE675 PhotoshopE675;

enum PhotoshopE680 {
	PhotoshopE680High = 'e107',
	PhotoshopE680Low = 'e101',
	PhotoshopE680Medium = 'Mdum'
};
typedef enum PhotoshopE680 PhotoshopE680;

enum PhotoshopE685 {
	PhotoshopE685EdgeOnly = 'e686',
	PhotoshopE685Normal = 'Nrml',
	PhotoshopE685OverlayEdge = 'e687'
};
typedef enum PhotoshopE685 PhotoshopE685;

enum PhotoshopE690 {
	PhotoshopE690Blocks = 'e691',
	PhotoshopE690Canvas = 'e692',
	PhotoshopE690Frosted = 'e693',
	PhotoshopE690TextureDocument = 'e695',
	PhotoshopE690TinyLens = 'e694'
};
typedef enum PhotoshopE690 PhotoshopE690;

enum PhotoshopE700 {
	PhotoshopE700PolarToRectangular = 'e702',
	PhotoshopE700RectangularToPolar = 'e701'
};
typedef enum PhotoshopE700 PhotoshopE700;

enum PhotoshopE710 {
	PhotoshopE710Large = 'Lrge',
	PhotoshopE710Medium = 'Mdum',
	PhotoshopE710Small = 'Smll'
};
typedef enum PhotoshopE710 PhotoshopE710;

enum PhotoshopE715 {
	PhotoshopE715RepeatEdgePixels = 'e717',
	PhotoshopE715WrapAround = 'e716'
};
typedef enum PhotoshopE715 PhotoshopE715;

enum PhotoshopE718 {
	PhotoshopE718RepeatEdgePixels = 'e717',
	PhotoshopE718SetToLayerFill = 'e719',
	PhotoshopE718WrapAround = 'e716'
};
typedef enum PhotoshopE718 PhotoshopE718;

enum PhotoshopE720 {
	PhotoshopE720Horizontal = 'e141',
	PhotoshopE720Normal = 'Nrml',
	PhotoshopE720Vertical = 'e142'
};
typedef enum PhotoshopE720 PhotoshopE720;

enum PhotoshopE725 {
	PhotoshopE725StretchToFit = 'e726',
	PhotoshopE725Tile = 'e727'
};
typedef enum PhotoshopE725 PhotoshopE725;

enum PhotoshopE730 {
	PhotoshopE730Sine = 'e731',
	PhotoshopE730Square = 'e733',
	PhotoshopE730Triangular = 'e732'
};
typedef enum PhotoshopE730 PhotoshopE730;

enum PhotoshopE740 {
	PhotoshopE740AroundCenter = 'e741',
	PhotoshopE740OutFromCenter = 'e742',
	PhotoshopE740PondRipples = 'e743'
};
typedef enum PhotoshopE740 PhotoshopE740;

enum PhotoshopE745 {
	PhotoshopE745Gaussian = 'e746',
	PhotoshopE745Uniform = 'e214'
};
typedef enum PhotoshopE745 PhotoshopE745;

enum PhotoshopE750 {
	PhotoshopE750MoviePrime = 'e753',
	PhotoshopE750Prime105 = 'e752',
	PhotoshopE750Prime35 = 'e751',
	PhotoshopE750Zoom = 'e672'
};
typedef enum PhotoshopE750 PhotoshopE750;

enum PhotoshopE755 {
	PhotoshopE755EvenFields = 'e757',
	PhotoshopE755OddFields = 'e756'
};
typedef enum PhotoshopE755 PhotoshopE755;

enum PhotoshopE760 {
	PhotoshopE760Duplication = 'e761',
	PhotoshopE760Interpolation = 'e762'
};
typedef enum PhotoshopE760 PhotoshopE760;

enum PhotoshopPT21 {
	PhotoshopPT21Clipping = 'PT05',
	PhotoshopPT21Normal = 'Nrml',
	PhotoshopPT21TextMask = 'PT58',
	PhotoshopPT21VectorMask = 'PT57',
	PhotoshopPT21Work = 'PT06'
};
typedef enum PhotoshopPT21 PhotoshopPT21;

enum PhotoshopPT45 {
	PhotoshopPT45ShapeAdd = 'PT46',
	PhotoshopPT45ShapeIntersect = 'PT48',
	PhotoshopPT45ShapeSubtract = 'PT49',
	PhotoshopPT45ShapeXor = 'PT47'
};
typedef enum PhotoshopPT45 PhotoshopPT45;

enum PhotoshopPT22 {
	PhotoshopPT22CornerPoint = 'PT24',
	PhotoshopPT22SmoothPoint = 'PT25'
};
typedef enum PhotoshopPT22 PhotoshopPT22;

enum PhotoshopPT23 {
	PhotoshopPT23ArtHistoryBrushTool = 'PT34',
	PhotoshopPT23BackgroundEraserTool = 'PT29',
	PhotoshopPT23BlurTool = 'PT36',
	PhotoshopPT23BrushTool = 'PT27',
	PhotoshopPT23BurnTool = 'PT39',
	PhotoshopPT23CloneStampTool = 'PT30',
	PhotoshopPT23ColorReplacementTool = 'PT41',
	PhotoshopPT23DodgeTool = 'PT38',
	PhotoshopPT23EraserTool = 'PT28',
	PhotoshopPT23HealingBrushTool = 'PT32',
	PhotoshopPT23HistoryBrushTool = 'PT33',
	PhotoshopPT23PatternStampTool = 'PT31',
	PhotoshopPT23PencilTool = 'PT26',
	PhotoshopPT23SharpenTool = 'PT37',
	PhotoshopPT23SmudgeTool = 'PT35',
	PhotoshopPT23SpongeTool = 'PT40'
};
typedef enum PhotoshopPT23 PhotoshopPT23;



/*
 * Core Suite
 */

// The Adobe Photoshop application
@interface PhotoshopApplication : SBApplication

- (SBElementArray *) documents;
- (SBElementArray *) fonts;
- (SBElementArray *) notifiers;

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy) PhotoshopColorValue *backgroundColor;
@property (copy, readonly) NSString *build;  // the build number of Adobe Photoshop application
@property (copy) id colorSettings;  // name of selected color settings' set
@property (copy) PhotoshopDocument *currentDocument;  // the frontmost document
@property PhotoshopE050 displayDialogs;  // controls whether or not Photoshop displays dialogs
@property (copy) PhotoshopColorValue *foregroundColor;
@property (readonly) double freeMemory;  // the amount of unused memory available to Adobe Photoshop
@property (readonly) BOOL frontmost;  // is Photoshop the frontmost application?
@property (copy, readonly) NSString *locale;  // language locale of application
@property (copy, readonly) NSArray *macintoshFileTypes;  // list of file image types Photoshop can open
@property (copy, readonly) NSString *name;  // the application's name
@property BOOL notifiersEnabled;  // enable or disable all notifiers
@property (copy, readonly) NSURL *preferencesFolder;  // full path to the preferences folder
@property (copy, readonly) NSArray *recentFiles;  // files in the recent file list
@property (copy, readonly) NSString *scriptingBuildDate;  // the build date of the scripting interface
@property (copy, readonly) NSString *scriptingVersion;  // the version of the Scripting interface
@property (copy, readonly) PhotoshopSettingsObject *settings;  // preference settings
@property (copy, readonly) NSString *systemInformation;  // system information of the host application and machine
@property (copy, readonly) NSString *version;  // the version of Adobe Photoshop application
@property (copy, readonly) NSArray *windowsFileTypes;  // list of file image extensions Photoshop can open

- (void) AETEScriptsScriptsJavaScriptNameName:(NSString *)JavaScriptNameName JavaScriptFileFile:(NSString *)JavaScriptFileFile JavaScriptTextText:(NSString *)JavaScriptTextText JavaScriptDebuggingDebugging:(BOOL)JavaScriptDebuggingDebugging JavaScriptMessageMessage:(NSString *)JavaScriptMessageMessage;  // Photoshop scripting support plug-in
- (void) open:(id)x as:(PhotoshopOpAs)as withOptions:(PhotoshopOpenOptions *)withOptions showingDialogs:(PhotoshopE050)showingDialogs smartObject:(BOOL)smartObject;  // open the specified document file(s)
- (void) print:(id)x sourceSpace:(PhotoshopE945)sourceSpace printSpace:(NSString *)printSpace intent:(PhotoshopE130)intent blackpointCompensation:(BOOL)blackpointCompensation;  // print the specified object(s)
- (void) quit;  // quit the application
- (NSArray *) PhotoshopOpenDialog;  // use the Photoshop open dialog to select files
- (NSString *) batch:(NSString *)x fromFiles:(NSArray *)fromFiles from:(NSString *)from withOptions:(PhotoshopBatchOptions *)withOptions;  // run the batch automation routine
- (NSString *) createPDFPresentationFromFiles:(NSArray *)fromFiles toFile:(NSURL *)toFile withOptions:(PhotoshopPresentationOptions *)withOptions;  // create a PDF presentation file
- (NSString *) createContactSheetFromFiles:(NSArray *)fromFiles withOptions:(PhotoshopContactSheetOptions *)withOptions;  // create a contact sheet from multiple files
- (NSString *) createPhotoGalleryFromFolder:(id)fromFolder toFolder:(NSURL *)toFolder withOptions:(PhotoshopGalleryOptions *)withOptions;  // Creates a web photo gallery
- (NSString *) createPhotoMergeFromFiles:(NSArray *)fromFiles;  // DEPRECATED. Merges multiple files into one, user interaction required.
- (NSString *) createPicturePackageFromFiles:(NSArray *)fromFiles withOptions:(PhotoshopPicturePackageOptions *)withOptions;  // create a picture package from multiple files
- (BOOL) featureEnabledName:(NSString *)name;  // is the feature with the given name enabled?
- (void) purge:(PhotoshopE150)x;  // purges one or more caches
- (void) refresh;  // pause the script until the application refreshes
- (PhotoshopRGBColor *) webSafeColorFor:(PhotoshopColorValue *)for_;  // find the closest web safe color for a color
- (void) clear;  // clear current selection
- (void) copy NS_RETURNS_NOT_RETAINED;  // copy current selection to the clipboard
- (void) copyMerged NS_RETURNS_NOT_RETAINED;  // copy current selection to the clipboard. Include data in all visible layers.
- (void) cut;  // cut current selection to the clipboard
- (void) doAction:(NSString *)x from:(NSString *)from;  // play an action from the Actions Palette
- (NSString *) doJavascript:(id)x withArguments:(NSArray *)withArguments showDebugger:(PhotoshopE940)showDebugger;  // execute a JavaScript
- (void) pasteClippingToSelection:(BOOL)clippingToSelection;  // paste clipboard into the current document

@end

// A document
@interface PhotoshopDocument : SBObject

- (SBElementArray *) artLayers;
- (SBElementArray *) channels;
- (SBElementArray *) colorSamplers;
- (SBElementArray *) countItems;
- (SBElementArray *) historyStates;
- (SBElementArray *) layerComps;
- (SBElementArray *) layers;
- (SBElementArray *) layerSets;
- (SBElementArray *) pathItems;

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (readonly) NSInteger index;  // the index of this instance of the object
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy, readonly) PhotoshopArtLayer *backgroundLayer;  // The background layer for the document. Only valid for documents that have a background layer
@property PhotoshopE815 bitsPerChannel;  // number of bits per channel
@property PhotoshopE090 colorProfileKind;  // Type of color profile management for document.  Note: If you want to set a custom color profile, do not set a value for color profile kind; rather, set the appropriate color profile name.
@property (copy) NSString *colorProfileName;  // Name of color profile for document. Valid when no value is specified for color profile kind (to indicate a custom color profile).
@property (copy, readonly) NSArray *componentChannels;  // all color component channels for this document
@property (copy) NSArray *currentChannels;  // selected channels for document
@property (copy) PhotoshopHistoryState *currentHistoryBrushSource;  // the current history state to use with the history brush for this document
@property (copy) PhotoshopHistoryState *currentHistoryState;  // the current history state for this document
@property (copy) PhotoshopLayer *currentLayer;  // selected layer for document
@property (copy, readonly) NSURL *filePath;  // full path name of document
@property (readonly) double height;  // height of document (unit value)
@property (copy, readonly) NSArray *histogram;  // a histogram of values for the composite document (only for RGB, CMYK and 'Indexed colors' documents)
- (NSInteger) id;  // the unique ID of this document
@property (copy, readonly) PhotoshopInfoObject *info;  // document information
@property (readonly) PhotoshopE110 initialFill;  // initial fill of the document. Only valid when used as an option with the 'make new document' command
@property (readonly) BOOL managed;  // is the document a workgroup document?
@property (copy, readonly) PhotoshopMeasurementScale *measurementScale;  // The measurement scale of the document
@property (readonly) PhotoshopE080 mode;  // document mode
@property (readonly) BOOL modified;  // has the document been modified since last save?
@property (copy, readonly) NSString *name;  // the document's name
@property double pixelAspectRatio;  // the pixel aspect ration of the document
@property BOOL quickMaskMode;  // is the document in the quick mask mode?
@property (readonly) double resolution;  // the resolution of the document (in pixels per inch)
@property (copy, readonly) PhotoshopSelectionObject *selection;  // the document's selection
@property (readonly) double width;  // width of document (unit value)
@property (copy, readonly) PhotoshopXMPMetadata *XMPMetadata;  // XMP metadata associated with the document

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) closeSaving:(PhotoshopSavo)saving;  // close the document
- (PhotoshopDocument *) duplicate;  // duplicate this document without parameters
- (PhotoshopDocument *) saveIn:(NSURL *)in_ as:(PhotoshopSvFm)as copying:(BOOL)copying appending:(PhotoshopE300)appending withOptions:(PhotoshopSaveOptions *)withOptions;  // save the specified document
- (void) autoCountFrom:(PhotoshopChannel *)from threshold:(NSInteger)threshold;  // automatically counts the objects in an image
- (void) changeModeTo:(PhotoshopE089)to withOptions:(PhotoshopChangeModeOptions *)withOptions;  // change the mode of the document
- (void) convertToProfile:(NSString *)toProfile intent:(PhotoshopE130)intent blackpointCompensation:(BOOL)blackpointCompensation dithering:(BOOL)dithering;  // convert the document from using one color profile to using an other
- (void) cropBounds:(NSArray *)bounds angle:(double)angle width:(double)width height:(double)height;  // crop the document
- (void) deselect;
- (PhotoshopDocument *) docDuplicateName:(NSString *)name mergeLayersOnly:(BOOL)mergeLayersOnly;  // duplicate this document with parameters
- (void) exportIn:(NSURL *)in_ as:(PhotoshopE640)as withOptions:(PhotoshopExportOptions *)withOptions;
- (void) flatten;  // Flattens all visible layers in the document.
- (void) flipCanvasDirection:(PhotoshopE140)direction;  // flip the canvas horizontally or vertically
- (void) importAnnotationsFrom:(NSURL *)from;  // import annotations into the document
- (void) mergeVisibleLayers;  // flatten all visible layers in the document
- (void) recordMeasurementsSource:(PhotoshopME00)source dataPoints:(NSArray *)dataPoints;  // record measurements of document
- (void) resizeCanvasWidth:(double)width height:(double)height anchorPosition:(PhotoshopE160)anchorPosition;  // change the size of the canvas
- (void) resizeImageWidth:(double)width height:(double)height resolution:(double)resolution resampleMethod:(PhotoshopE175)resampleMethod amount:(NSInteger)amount;  // change the size of the image
- (void) revealAll;  // expand document to show clipped sections
- (void) rotateCanvasAngle:(double)angle;  // rotate canvas of document
- (void) selectRegion:(NSArray *)region combinationType:(PhotoshopE630)combinationType featherAmount:(double)featherAmount antialiasing:(BOOL)antialiasing;  // change the selection
- (void) selectAll;  // select the entire image
- (NSArray *) splitChannels;  // split channels of the document
- (void) trapWidth:(NSInteger)width;  // apply trap to a CMYK document
- (void) trimBasingTrimOn:(PhotoshopE350)basingTrimOn topTrim:(BOOL)topTrim leftTrim:(BOOL)leftTrim bottomTrim:(BOOL)bottomTrim rightTrim:(BOOL)rightTrim;

@end



/*
 * Photoshop Suite
 */

// options for the Batch command
@interface PhotoshopBatchOptions : SBObject

@property PhotoshopBT14 destination;  // final destination of processed files ( default: none )
@property (copy) NSURL *destinationFolder;  // folder location when using destination to a folder
@property (copy) NSURL *errorFile;  // file to log errors encountered, leave this blank to stop for errors
@property (copy) NSArray *fileNaming;  // list of file naming options 6 max.
@property BOOL macintoshCompatible;  // make final file name Macintosh compatible ( default: true )
@property BOOL overrideOpen;  // override action open commands ( default: false )
@property BOOL overrideSave;  // override save as action steps with destination specified here ( default: false )
@property NSInteger startingserial;  // starting serial number to use ( default: 1 )
@property BOOL suppressOpen;  // suppress file open options dialogs ( default: false )
@property BOOL suppressprofile;  // suppress color profile warnings ( default: false )
@property BOOL unixCompatible;  // make final file name Unix compatible ( default: true )
@property BOOL windowsCompatible;  // make final file name Windows compatible ( default: true )

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// used with options on the 'change mode' command
@interface PhotoshopChangeModeOptions : SBObject

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Settings related to changing the document mode to Bitmap
@interface PhotoshopBitmapModeOptions : PhotoshopChangeModeOptions

@property double angle;  // only valid for 'halftone screen' conversions
@property PhotoshopE860 conversionMethod;  // ( default: diffusion dither )
@property double frequency;  // only valid for 'halftone screen' conversions
@property (copy) NSString *patternName;  // only valid for 'custom pattern' conversions
@property double resolution;  // output resolution (in pixels per inch) ( default: 72.0 )
@property PhotoshopE870 screenShape;  // only valid for 'halftone screen' conversions


@end

// A channel in a document. Can be either a component channel representing a color of the document color model or an alpha channel
@interface PhotoshopChannel : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (readonly) NSInteger index;  // the index of this instance of the object
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy) PhotoshopColorValue *channelColor;  // color of the channel (not valid for component channels)
@property (copy, readonly) SBObject *container;  // the object's container
@property (copy, readonly) NSArray *histogram;  // a histogram of values for the channel
@property PhotoshopE660 kind;  // type of the channel
@property (copy) NSString *name;  // the channel's name
@property double opacity;  // opacity of alpha channels (called solidity for spot channels)
@property BOOL visible;

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) merge;  // Merges an art layer or layer set into the layer below, or merges a spot channel into the component channels. Merging a layer or layer set returns a reference to the resulting layer. Merging a channel does not return any value.

@end

// A color sampler in a document. See the color sampler tool.
@interface PhotoshopColorSampler : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (readonly) NSInteger index;  // the index of this instance of the object
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy, readonly) PhotoshopColorValue *colorSamplerColor;  // color of the color sampler
@property (copy, readonly) SBObject *container;  // the object's container
@property (copy, readonly) NSArray *position;  // position of the color sampler (unit value)

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Options for the Contact Sheet command
@interface PhotoshopContactSheetOptions : SBObject

@property BOOL acrossFirst;  // place the images horizontally first ( default: true )
@property BOOL autoSpacing;  // auto space the images in the contact sheet ( default: true )
@property BOOL bestFit;  // rotate images for best fit ( default: false )
@property BOOL caption;  // use the filename as a caption for the image ( default: true )
@property NSInteger columnCount;  // contact sheet columns ( default: 5 )
@property BOOL flattenFinal;  // flatten all layers in the final document ( default: true )
@property PhotoshopPGa2 font;  // font used for the caption ( default: Arial )
@property NSInteger fontSize;  // font size used for the caption ( default: 12 )
@property NSInteger height;  // height of the resulting document in pixels ( default: 720 )
@property NSInteger horizontalOffset;  // horizontal spacing between images in pixels ( default: 1 )
@property PhotoshopE905 mode;  // document mode (Grayscale, RGB, CMYK or Lab) ( default: RGB )
@property double resolution;  // the resolution of the document (in pixels per inch) ( default: 72.0 )
@property NSInteger rowCount;  // contact sheet rows ( default: 6 )
@property NSInteger verticalOffset;  // vertical spacing between images in pixels ( default: 1 )
@property NSInteger width;  // width of the resulting document in pixels ( default: 576 )

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// A counted item in a document. See the counting tool.
@interface PhotoshopCountItem : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (readonly) NSInteger index;  // the index of this instance of the object
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy, readonly) SBObject *container;  // the object's container
@property (copy, readonly) NSArray *position;  // position of count item (unit value)

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// An installed font
@interface PhotoshopFont : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (readonly) NSInteger index;  // the index of this instance of the object
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy, readonly) NSString *family;  // the font's family
@property (copy, readonly) NSString *name;  // The font's text face name
@property (copy, readonly) NSString *PostScriptName;  // the font's PostScript name
@property (copy, readonly) NSString *style;  // the font's style name

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Options for the web photo gallery banner options
@interface PhotoshopGalleryBannerOptions : SBObject

@property (copy) NSString *contactInfo;  // web photo gallery contact info ( default:  )
@property (copy) NSString *date;  // web photo gallery date ( default:  )
@property PhotoshopPGa2 font;  // the font setting for the banner text ( default: Arial )
@property NSInteger fontSize;  // the size of the font for the banner text ( 1 - 7; default: 3 )
@property (copy) NSString *photographer;  // web photo gallery photographer ( default:  )
@property (copy) NSString *siteName;  // web photo gallery site name ( default: Adobe Web Photo Gallery )

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Options for the web photo gallery colors
@interface PhotoshopGalleryColorOptions : SBObject

@property (copy) PhotoshopRGBColor *activeLinkColor;  // active link color
@property (copy) PhotoshopRGBColor *backgroundColor;  // background color
@property (copy) PhotoshopRGBColor *bannerColor;  // banner color
@property (copy) PhotoshopRGBColor *linkColor;  // link color
@property (copy) PhotoshopRGBColor *textColor;  // text color
@property (copy) PhotoshopRGBColor *visitedLinkColor;  // visited link color

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Options for the web photo gallery images
@interface PhotoshopGalleryImagesOptions : SBObject

@property NSInteger border;  // the amount of border pixels you want between your images ( 0 - 99; default: 0 )
@property BOOL caption;  // generate a caption for the images ( default: false )
@property NSInteger dimension;  // resized image dimensions in pixels ( default: 350 )
@property PhotoshopPGa2 font;  // font for the gallery images text ( default: Arial )
@property NSInteger fontSize;  // font size for the gallery images text ( 1 - 7; default: 3 )
@property NSInteger imageQuality;  // the quality setting for the JPEG image ( 0 - 12; default: 5 )
@property BOOL includeCopyright;  // include the copyright in the text for the gallery images ( default: false )
@property BOOL includeCredits;  // include the credits in the text for the gallery images ( default: false )
@property BOOL includeFileName;  // include the file name in the text for the gallery images ( default: true )
@property BOOL includeTitle;  // include the title in the text for the gallery images ( default: false )
@property BOOL numericLinks;  // add numeric links ( default: true )
@property PhotoshopPGa3 resizeConstraint;  // how should the image be constrained ( default: constrain both )
@property BOOL resizeImages;  // resize images data ( default: true )

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Options for the web photo gallery command
@interface PhotoshopGalleryOptions : SBObject

@property (copy) PhotoshopGalleryBannerOptions *bannerOptions;  // options related to banner settings
@property (copy) PhotoshopGalleryColorOptions *customColorOptions;  // options related to custom color settings
@property (copy) NSString *emailAddress;  // the email address to show on the web page ( default:  )
@property (copy) PhotoshopGalleryImagesOptions *imagesOptions;  // options related to images settings
@property (copy) NSString *layoutStyle;  // the style to use for laying out the web page ( default: Centered Frame 1 - Basic )
@property BOOL preserveAllMetadata;  // save all of the metadata in the JPEG files ( default: false )
@property (copy) PhotoshopGallerySecurityOptions *securityOptions;  // options related to security settings
@property BOOL shortExtension;  // short web page extension .htm or long web page extension .html ( default: true )
@property BOOL sizeAttributes;  // add width and height attributes for images ( default: true )
@property BOOL subFolders;  // include all files found in sub folders of the input folder ( default: true )
@property (copy) PhotoshopGalleryThumbnailOptions *thumbnailOptions;  // options related to thumbnail settings
@property BOOL UTF8Encoding;  // web page should use UTF-8 encoding ( default: false )

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Options for the web photo gallery security
@interface PhotoshopGallerySecurityOptions : SBObject

@property PhotoshopPGa5 content;  // web photo gallery security content ( default: gallery none )
@property (copy) NSString *customText;  // web photo gallery security custom text ( default:  )
@property PhotoshopPGa2 font;  // web photo gallery security font ( default: Arial )
@property NSInteger fontSize;  // web photo gallery security font size ( minimum 1; default: 36 )
@property NSInteger opacity;  // web page security opacity as a percent ( default: 100 )
@property (copy) PhotoshopRGBColor *textColor;  // web page security text color
@property PhotoshopPGa7 textPosition;  // web photo gallery security text position ( default: gallery centered )
@property PhotoshopPGa8 textRotate;  // web photo gallery security text rotate ( default: zero )

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Options for the web photo gallery thumbnail creation
@interface PhotoshopGalleryThumbnailOptions : SBObject

@property NSInteger border;  // the amount of border pixels you want around your thumbnail images ( 0 - 99; default: 0 )
@property BOOL caption;  // with caption ( default: false )
@property NSInteger columnCount;  // web photo gallery thumbnail columns ( default: 5 )
@property NSInteger dimension;  // web photo gallery thumbnail dimension in pixels ( default: 75 )
@property PhotoshopPGa2 font;  // web photo gallery font ( default: Arial )
@property NSInteger fontSize;  // the size of the font for the thumbnail images text ( 1 - 7; default: 3 )
@property BOOL includeCopyright;  // include copyright for thumbnail ( default: false )
@property BOOL includeCredits;  // include credits for thumbnail ( default: false )
@property BOOL includeFileName;  // include file name for thumbnail ( default: false )
@property BOOL includeTitle;  // include title for thumbnail ( default: false )
@property NSInteger rowCount;  // web photo gallery thumbnail rows ( default: 3 )
@property PhotoshopPGa4 size;  // the size of the thumbnail images ( default: gallery medium )

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// A history state for the document
@interface PhotoshopHistoryState : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (readonly) NSInteger index;  // the index of this instance of the object
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy, readonly) SBObject *container;  // the object's container
@property (copy, readonly) NSString *name;  // the history state's name
@property (readonly) BOOL snapshot;  // is the history state a snapshot?

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Settings related to changing the document mode to Indexed
@interface PhotoshopIndexedModeOptions : PhotoshopChangeModeOptions

@property NSInteger colorsInPalette;  // number of colors in palette (only settable for some palette types)
@property PhotoshopE230 dither;  // type of dither
@property NSInteger ditherAmount;  // amount of dither. Only valid for diffusion ( 1 - 100 )
@property PhotoshopE200 forcedColors;
@property PhotoshopE880 matte;
@property PhotoshopE210 palette;  // Type of palette ( default: exact )
@property BOOL preserveExactColors;
@property BOOL transparency;


@end

// Document information
@interface PhotoshopInfoObject : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy) NSString *author;
@property (copy) NSString *authorPosition;
@property (copy) NSString *caption;
@property (copy) NSString *captionWriter;
@property (copy) NSString *category;
@property (copy) NSString *city;
@property (copy, readonly) SBObject *container;  // the object's container
@property (copy) NSString *copyrightNotice;
@property PhotoshopE850 copyrighted;
@property (copy) NSString *country;
@property (copy) NSString *creationDate;
@property (copy) NSString *credit;
@property (copy, readonly) NSArray *EXIF;
@property (copy) NSString *headline;
@property (copy) NSString *instructions;
@property (copy) NSString *jobName;
@property (copy) NSArray *keywords;  // list of keywords
@property (copy) NSString *ownerUrl;
@property (copy) NSString *provinceOrState;
@property (copy) NSString *source;
@property (copy) NSArray *supplementalCategories;
@property (copy) NSString *title;
@property (copy) NSString *transmissionReference;
@property PhotoshopE100 urgency;

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// A layer object
@interface PhotoshopLayer : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (readonly) NSInteger index;  // the index of this instance of the object
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property BOOL allLocked;
@property PhotoshopE470 blendMode;
@property (copy, readonly) NSArray *bounds;  // Bounding rectangle of the Layer
@property (copy, readonly) SBObject *container;  // the object's container
- (NSInteger) id;  // the unique ID of this layer
@property (readonly) NSInteger itemindex;  // the layer index sans layer groups, how Photoshop would index them
@property (copy, readonly) NSArray *linkedLayers;
@property (copy) NSString *name;  // the name of the layer
@property double opacity;  // master opacity of layer ( 0.0 - 100.0 )
@property BOOL visible;

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) linkWith:(PhotoshopLayer *)with;  // link the layer with another layer
- (void) rotateAngle:(double)angle anchorPosition:(PhotoshopE160)anchorPosition;
- (void) scaleHorizontalScale:(double)horizontalScale verticalScale:(double)verticalScale anchorPosition:(PhotoshopE160)anchorPosition;
- (void) translateDeltaX:(double)deltaX deltaY:(double)deltaY;  // moves the position relative to its current position
- (void) unlink;  // unlink the layer

@end

// any layer that can contain data
@interface PhotoshopArtLayer : PhotoshopLayer

@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property BOOL backgroundLayer;  // is the layer a background layer?
@property double fillOpacity;  // the interior opacity of the layer (between 0.0 and 100.0)
@property BOOL grouped;  // is the layer grouped with the layer below?. Photoshop CS changed the menu name to Create/Release Clipping Mask
@property PhotoshopE950 kind;  // to create a text layer set this property to 'text layer' on an empty art layer of type 'normal'
@property BOOL pixelsLocked;
@property BOOL positionLocked;
@property (copy, readonly) PhotoshopTextObject *textObject;  // the text that is associated with the art layer. Only valid for art layers whose 'kind' is a text layer
@property BOOL transparentPixelsLocked;

- (void) applyLayerStyleUsing:(NSString *)using_;
- (void) rasterizeAffecting:(PhotoshopE510)affecting;
- (void) filterUsing:(id)using_ withOptions:(PhotoshopFilterOptions *)withOptions;  // apply a filter to one or more art layers
- (void) adjustUsing:(id)using_ withOptions:(PhotoshopAdjustmentOptions *)withOptions;  // apply an adjustment to one or more art layers

@end

// A layer composition in a document
@interface PhotoshopLayerComp : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (readonly) NSInteger index;  // the index of this instance of the object
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property BOOL appearance;  // use layer appearance
@property (copy) id comment;  // the description of the layer comp
@property (copy, readonly) SBObject *container;  // the object's container
@property (copy) NSString *name;  // the name of the layer comp
@property BOOL position;  // use layer position
@property (readonly) BOOL selected;  // the layer comp is currently selected
@property BOOL visibility;  // use layer visibility

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) apply;  // apply the layer comp to the document
- (void) recapture;  // recapture the current layer state(s) for this layer comp
- (void) resetFromComp;  // reset the layer comp state to the document state

@end

// Layer set
@interface PhotoshopLayerSet : PhotoshopLayer

- (SBElementArray *) artLayers;
- (SBElementArray *) layers;
- (SBElementArray *) layerSets;

@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy) NSArray *enabledChannels;  // channels that are enabled for the layer set. Must be a list of component channels


@end

// Document Measurement Scale
@interface PhotoshopMeasurementScale : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy, readonly) SBObject *container;  // the object's container
@property double logicalLength;  // the logical length this scale equates to
@property (copy) NSString *logicalUnits;  // the logical units for this scale
@property (copy) NSString *name;  // the name of this scale
@property NSInteger pixelLength;  // the length in pixels this scale equates to

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// options for the Picture Package command
@interface PhotoshopPicturePackageOptions : SBObject

@property PhotoshopPP09 content;  // content information ( default: no text )
@property (copy) NSString *customText;  // picture package custom text ( default:  )
@property BOOL flattenFinal;  // flatten all layers in the final document ( default: true )
@property PhotoshopPGa2 font;  // font used for the text ( default: Arial )
@property NSInteger fontSize;  // font size used for the caption ( default: 12 )
@property (copy) NSString *layout;  // layout to use to generate the picture package ( default: (2)5x7 )
@property PhotoshopE905 mode;  // document mode (Grayscale, RGB, CMYK or Lab) ( default: RGB )
@property NSInteger opacity;  // web page security opacity as a percent ( default: 100 )
@property double resolution;  // the resolution of the document (in pixels per inch) ( default: 72.0 )
@property (copy) PhotoshopRGBColor *textColor;  // text color
@property PhotoshopPGa7 textPosition;  // text position ( default: gallery centered )
@property PhotoshopPGa8 textRotate;  // text rotate ( default: zero )

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// options for the PDF presentation command
@interface PhotoshopPresentationOptions : SBObject

@property BOOL autoAdvance;  // auto advance when viewing ( default: true )
@property BOOL includeFileName;  // include file name for image ( default: false )
@property NSInteger interval;  // time in seconds before auto advancing the view ( default: 5 )
@property BOOL loop;  // loop after last page ( default: false )
@property PhotoshopPDFx magnification;  // magnification type when viewing the image ( default: actual size )
@property (copy) PhotoshopPDFSaveOptions *PDFOptions;  // Options used when creating the PDF file
@property BOOL presentation;  // true if the file type is presentation false for Multi-Page document ( default: false )
@property PhotoshopPDFb transition;  // transition type when switching to the next document ( default: none )

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// The selection of the document
@interface PhotoshopSelectionObject : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy, readonly) NSArray *bounds;  // bounding rectangle of the entire selection
@property (copy, readonly) SBObject *container;  // the object's container
@property (readonly) BOOL solid;  // is the bounding rectangle a solid rectangle

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) contractBy:(double)by;  // contracts the selection
- (void) expandBy:(double)by;  // expand selection
- (void) featherBy:(double)by;  // feather edges of selection
- (void) fillWithContents:(id)withContents blendMode:(PhotoshopE925)blendMode opacity:(NSInteger)opacity preservingTransparency:(BOOL)preservingTransparency;  // fills the selection
- (void) growTolerance:(NSInteger)tolerance antialiasing:(BOOL)antialiasing;  // grow selection to include all adjacent pixels falling within the specified tolerance range
- (void) invert;  // invert the selection
- (void) loadFrom:(PhotoshopChannel *)from combinationType:(PhotoshopE630)combinationType inverting:(BOOL)inverting;  // load the selection from a channel
- (void) makeWorkPathTolerance:(double)tolerance;  // make this selection item the work path for this document
- (void) rotateBoundaryAngle:(double)angle anchorPosition:(PhotoshopE160)anchorPosition;  // rotates the boundary of selection
- (void) scaleBoundaryHorizontalScale:(double)horizontalScale verticalScale:(double)verticalScale anchorPosition:(PhotoshopE160)anchorPosition;  // scale the boundary of selection
- (void) selectBorderWidth:(double)width;  // select the border of the selection
- (void) similarTolerance:(NSInteger)tolerance antialiasing:(BOOL)antialiasing;  // grow selection to include pixels throughout the image falling within the tolerance range
- (void) smoothRadius:(NSInteger)radius;
- (void) storeInto:(PhotoshopChannel *)into combinationType:(PhotoshopE630)combinationType;  // save the selection as a channel
- (void) strokeUsingColor:(id)usingColor width:(NSInteger)width location:(PhotoshopE920)location blendMode:(PhotoshopE925)blendMode opacity:(NSInteger)opacity preservingTransparency:(BOOL)preservingTransparency;  // strokes the selection
- (void) translateBoundaryDeltaX:(double)deltaX deltaY:(double)deltaY;  // moves the boundary of selection relative to its current position

@end

// Preferences for Photoshop
@interface PhotoshopSettingsObject : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy) NSURL *additionalPluginFolder;
@property PhotoshopE400 appendExtension;
@property BOOL askBeforeSavingLayeredTIFF;
@property BOOL autoUpdateOpenDocuments;
@property BOOL beepWhenDone;
@property NSInteger cacheLevels;
@property PhotoshopE360 colorPicker;
@property double columnGutter;  // gutter of columns (in points)
@property double columnWidth;  // width of columns (in points)
@property BOOL createFirstSnapshot;  // automatically make first snapshot when a new document is created?
@property BOOL displayColorChannelsInColor;
@property BOOL dynamicColorSliders;
@property PhotoshopPr53 editLogItems;  // options for edit log items
@property BOOL exportClipboard;
@property PhotoshopFP00 fontPreviewSize;  // show font previews in the type tool font menus
@property BOOL fullSizePreview;
@property double gamutWarningOpacity;
@property PhotoshopE420 gridSize;
@property PhotoshopE460 gridStyle;
@property NSInteger gridSubdivisions;
@property PhotoshopE464 guideStyle;
@property BOOL iconPreview;
@property PhotoshopE400 imagePreviews;
@property PhotoshopE175 interpolationMethod;
@property BOOL keyboardZoomResizesWindows;
@property BOOL MacOSThumbnail;
@property PhotoshopMX00 maximizeCompatibility;  // maximize compatibility for Photoshop (PSD) files
@property NSInteger maximumRAMUse;  // Maximum percentage of available RAM used by Photoshop ( 5 - 100 )
@property BOOL nonlinearHistory;  // allow non-linear history?
@property NSInteger numberOfHistoryStates;  // number of history states to remember (between 1 and 100)
@property PhotoshopE415 otherCursors;
@property PhotoshopE410 paintingCursors;
@property BOOL pixelDoubling;
@property PhotoshopE450 pointSize;  // size of point/pica
@property NSInteger recentFileListLength;  // number of items in the recent file list (between 0 and 30)
@property PhotoshopE440 rulerUnits;  // Note: this is the unit that the scripting system will use when receiving and returning values
@property PhotoshopPr49 saveLogItems;  // options for saving the history items
@property (copy) NSURL *saveLogItemsFile;  // file to save the history log
@property BOOL savePaletteLocations;
@property BOOL showAsianTextOptions;
@property BOOL showEnglishFontNames;
@property BOOL showSliceNumbers;
@property BOOL showToolTips;
@property BOOL smartQuotes;
@property PhotoshopE445 typeUnits;
@property BOOL useAdditionalPluginFolder;
@property BOOL useCacheForHistograms;
@property BOOL useDiffusionDither;
@property BOOL useHistoryLog;  // Turn on and off the history logging
@property BOOL useLowercaseExtension;  // should the file extension be lowercase
@property BOOL useShiftKeyForToolSwitch;
@property BOOL useVideoAlpha;  // this option requires hardware support
@property BOOL WindowsThumbnail;

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Text object contained in an art layer
@interface PhotoshopTextObject : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property BOOL alternateLigatures;  // use alternate ligatures?
@property PhotoshopE530 antialiasMethod;
@property PhotoshopE980 autoKerning;  // options for auto kerning
@property BOOL autoLeading;  // whether to use a font's built-in leading information
@property double autoLeadingAmount;  // percentage to use for auto leading
@property double baselineShift;  // baseline offset of text (unit value)
@property PhotoshopE540 capitalization;  // the case of the text
@property (copy, readonly) SBObject *container;  // the object's container
@property (copy) NSString *contents;  // the text in the layer
@property double desiredGlyphScaling;
@property double desiredLetterScaling;
@property double desiredWordScaling;
@property BOOL fauxBold;  // use faux bold?
@property BOOL fauxItalic;  // use faux italic?
@property double firstLineIndent;  // (unit value)
@property (copy) NSString *font;  // text face of the character
@property double height;  // the height of paragraph text (unit value)
@property NSInteger horizontalScale;  // horizontal scaling of characters (in percent)
@property double horizontalWarpDistortion;  // percentage from -100 to 100
@property NSInteger hyphenLimit;  // maximum number of consecutive hyphens
@property NSInteger hyphenateAfterFirst;  // hyphenate after this many letters
@property NSInteger hyphenateBeforeLast;  // hyphenate before this many letters
@property BOOL hyphenateCapitalizedWords;  // wheter to hyphenate capitalized words
@property NSInteger hyphenateWordsLongerThan;  // hyphenate words that have more than this number of letters ( minimum 0 )
@property BOOL hyphenation;  // use hyphenation?
@property double hyphenationZone;  // the hyphenation zone (unit value)
@property PhotoshopE520 justification;  // paragraph justification
@property PhotoshopE580 kind;  // the type of the text
@property PhotoshopE560 language;
@property double leading;  // leading (unit value)
@property double leftIndent;  // (unit value)
@property BOOL ligatures;  // use ligatures?
@property double maximumGlyphScaling;
@property double maximumLetterScaling;
@property double maximumWordScaling;
@property double minimumGlyphScaling;
@property double minimumLetterScaling;
@property double minimumWordScaling;
@property BOOL noBreak;
@property BOOL oldStyle;  // use old style?
@property (copy) NSArray *position;  // position of origin (unit value)
@property double rightIndent;  // (unit value)
@property BOOL RomanHangingPunctuation;  // use Roman Hanging Punctuation?
@property double size;  // font size in points
@property double spaceAfter;  // (unit value)
@property double spaceBefore;  // (unit value)
@property PhotoshopE990 strikeThru;  // options for strik thru of the text
@property (copy) PhotoshopColorValue *strokeColor;  // color of text
@property PhotoshopE590 textComposer;  // type of text composing engine to use
@property PhotoshopE140 textDirection;  // text orientation
@property double tracking;  // controls uniform spacing between multiple characters
@property PhotoshopEA00 underline;  // options for underlining of the text
@property NSInteger verticalScale;  // vertical scaling of characters (in percent)
@property double verticalWarpDistortion;  // percentage from -100 to 100
@property double warpBend;  // percentage from -100 to 100
@property PhotoshopE140 warpDirection;
@property PhotoshopE600 warpStyle;
@property double width;  // the width of paragraph text (unit value)

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) convertToShape;  // converts the text object and its containing layer to a fill layer with the text changed to a clipping path
- (void) createWorkPath;  // creates a work path based on the text object

@end

@interface PhotoshopXMPMetadata : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy, readonly) SBObject *container;  // the object's container
@property (copy) NSString *rawData;  // raw XML form of file information

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end



/*
 * Open Formats Suite
 */

// used with options on the open command
@interface PhotoshopOpenOptions : SBObject

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Settings related to opening a camera RAW document
@interface PhotoshopCameraRAWOpenOptions : PhotoshopOpenOptions

@property PhotoshopE815 bitsPerChannel;  // number of bits per channel
@property NSInteger blueHue;  // the blue hue of the shot
@property NSInteger blueSaturation;  // the blue saturation of the shot
@property NSInteger brightness;  // the brightness of the shot
@property NSInteger chromaticAberrationBy;  // the chromatic aberration B/Y of the shot
@property NSInteger chromaticAberrationRc;  // the chromatic aberration R/C of the shot
@property NSInteger colorNoiseReduction;  // the color noise reduction of the shot
@property PhotoshopCR46 colorSpace;  // colorspace for image
@property NSInteger contrast;  // the constrast of the shot
@property double exposure;  // the exposure of the shot
@property NSInteger greenHue;  // the green hue of the shot
@property NSInteger greenSaturation;  // the green saturation of the shot
@property NSInteger luminanceSmoothing;  // the luminance smoothing of the shot
@property NSInteger redHue;  // the red hue of the shot
@property NSInteger redSaturation;  // the red saturation of the shot
@property double resolution;  // the resolution of the document (in pixels per inch)
@property NSInteger saturation;  // the saturation of the shot
@property PhotoshopCR02 settings;  // global settings for all Camera RAW options ( default: camera default )
@property NSInteger shadowTint;  // the shadow tint of the shot
@property NSInteger shadows;  // the shadows of the shot
@property NSInteger sharpness;  // the sharpness of the shot
@property PhotoshopCR34 size;  // size of the new document
@property NSInteger temperature;  // the temperature of the shot
@property NSInteger tint;  // the tint of the shot
@property NSInteger vignettingAmount;  // the vignetting amount of the shot
@property NSInteger vignettingMidpoint;  // the vignetting mid point of the shot
@property PhotoshopCR05 whiteBalance;  // white balance options for the image


@end

// Settings related to opening a DICOM document
@interface PhotoshopDICOMOpenOptions : PhotoshopOpenOptions

@property BOOL anonymize;  // Anonymize the patient information
@property NSInteger columns;  // The number of columns in n-up configuration
@property BOOL reverse;  // Reverse(Invert) the image
@property NSInteger rows;  // The number of rows in n-up configuration
@property BOOL show_overlays;  // Show Overlays (if present)
@property NSInteger windowlevel;  // Window Level
@property NSInteger windowwidth;  // Window Width


@end

// Settings related to opening a generic EPS document
@interface PhotoshopEPSOpenOptions : PhotoshopOpenOptions

@property BOOL constrainProportions;  // constrain proportions of image
@property double height;  // height of image (unit value)
@property PhotoshopE900 mode;  // the document mode
@property double resolution;  // the resolution of the document (in pixels per inch)
@property BOOL useAntialias;  // use antialias?
@property double width;  // width of image (unit value)


@end

// Settings related to opening a generic PDF document
@interface PhotoshopPDFOpenOptions : PhotoshopOpenOptions

@property PhotoshopE815 bitsPerChannel;  // number of bits per channel
@property BOOL constrainProportions;  // DEPRECATED, no longer used in CS2 ( constrain proportions of image )
@property PhotoshopCrtO cropPage;  // crop the page
@property double height;  // DEPRECATED, no longer used in CS2  ( height of image (unit value) )
@property PhotoshopE900 mode;  // the document mode
@property (copy) NSString *name;  // name of the new document
@property NSInteger page;  // number of page or image to open
@property double resolution;  // the resolution of the document (in pixels per inch)
@property BOOL suppressWarnings;  // supress any warnings that may occur during opening
@property BOOL useAntialias;  // use antialias?
@property BOOL usePageNumber;  // page property refers to page number, if false page property refers to image number
@property double width;  // DEPRECATED, no longer used in CS2  ( width of image (unit value) )


@end

// Settings related to opening a PhotoCD document
@interface PhotoshopPhotoCDOpenOptions : PhotoshopOpenOptions

@property (copy) NSString *colorProfileName;  // profile to use when reading the image
@property PhotoshopE910 colorSpace;  // colorspace for image
@property PhotoshopDori orientation;
@property PhotoshopE810 pixelSize;  // dimensions of image
@property double resolution;  // the resolution of the image (in pixels per inch)


@end

// Settings related to opening a raw format document
@interface PhotoshopRawFormatOpenOptions : PhotoshopOpenOptions

@property NSInteger bitsPerChannel;  // number of bits for each channel (8 or 16)
@property PhotoshopE330 byteOrder;  // only relevant for images with 16 bits per channel
@property NSInteger headerSize;
@property NSInteger height;  // height of image (in pixels)
@property BOOL interleaveChannels;  // are the channels in the image interleaved?
@property NSInteger numberOfChannels;  // number of channels in image
@property BOOL retainHeader;  // retain header when saving?
@property NSInteger width;  // width of image (in pixels)


@end



/*
 * Save Formats Suite
 */

// used with options on the save command
@interface PhotoshopSaveOptions : SBObject

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Settings related to saving a BMP document
@interface PhotoshopBMPSaveOptions : PhotoshopSaveOptions

@property PhotoshopE820 bitsPerSample;  // number of bits per sample ( default: twenty four )
@property BOOL flippedRowOrder;
@property BOOL RLECompression;  // should RLE compression be used?
@property BOOL saveAlphaChannels;  // save alpha channels
@property PhotoshopE191 targetOperatingSystem;  // target OS. Windows or OS/2 ( default: Windows )


@end

// Settings related to saving an EPS document
@interface PhotoshopEPSSaveOptions : PhotoshopSaveOptions

@property BOOL embedColorProfile;  // embed color profile in document
@property PhotoshopE260 encoding;  // type of encoding to use for document ( default: binary )
@property BOOL halftoneScreen;  // include halftone screen ( default: false )
@property BOOL imageInterpolation;  // use image interpolation ( default: false )
@property BOOL PostScriptColorManagement;  // use Postscript color management ( default: false )
@property PhotoshopE250 previewType;  // type of preview ( default: monochrome TIFF )
@property BOOL transferFunction;  // include transfer functions in document ( default: false )
@property BOOL transparentWhites;  // only valid when saving BitMap documents
@property BOOL vectorData;  // include vector data


@end

// Settings related to saving a GIF document
@interface PhotoshopGIFSaveOptions : PhotoshopSaveOptions

@property NSInteger colorsInPalette;  // number of colors in palette (only settable for some palette types)
@property PhotoshopE230 dither;  // type of dither
@property NSInteger ditherAmount;  // amount of dither. Only valid for diffusion ( 1 - 100; default: 75 )
@property PhotoshopE200 forcedColors;
@property BOOL interlaced;  // should rows be interlaced? ( default: false )
@property PhotoshopE880 matte;
@property PhotoshopE210 palette;  // ( default: local selective )
@property BOOL preserveExactColors;
@property BOOL transparency;


@end

// Settings related to saving a JPEG document
@interface PhotoshopJPEGSaveOptions : PhotoshopSaveOptions

@property BOOL embedColorProfile;  // embed color profile in document
@property PhotoshopE270 formatOptions;  // ( default: standard )
@property PhotoshopE880 matte;
@property NSInteger quality;  // quality of produced image ( 0 - 12; default: 3 )
@property NSInteger scans;  // number of scans. Only valid for progressive type JPEG files ( 3 - 5 )


@end

// Settings related to saving a pdf document
@interface PhotoshopPDFSaveOptions : PhotoshopSaveOptions

@property BOOL colorConversion;  // convert the color profile to a destination profile
@property (copy) NSString *objectDescription;  // description of the save options in use
@property (copy) NSString *destinationProfile;  // describes the final RGB or CMYK output device, such as your monitor or a certain press standard
@property PhotoshopPD16 downSample;  // down sample method to use
@property double downSampleLimit;  // limits downsampleing/subsampling to images that exceed this value (in pixels per inch)
@property double downSampleSize;  // down sample images to this size if they exceed limit (in pixels per inch)
@property BOOL downgradeColorProfile;  // DEPRECATED, no longer used in CS2 ( should the embedded color profile be downgraded to version 2 )
@property BOOL eightConvert;  // converts a 16-bit image to 8-bit for better compatibility with other applications
@property BOOL embedColorProfile;  // embed color profile in document
@property BOOL embedFonts;  // DEPRECATED, no longer used in CS2 ( embed fonts? Only valid if a text layer is included )
@property BOOL embedThumbnail;  // Includes a small preview image in Acrobat
@property PhotoshopE280 encoding;  // ZIP, JPEG and JPEG2000 encoding and compression options
@property BOOL imageInterpolation;  // DEPRECATED, no longer used in CS2 ( use image interpolation? )
@property NSInteger JPEGQuality;  // Only valid for JPEG encoding. Use encoding options instead of this property. Quality of produced image. Only valid for JPEG encoded PDF documents ( 0 - 12 )
@property (copy) NSString *outputCondition;  // an optional comment field for inserting descriptions of the output condition. The text is stored in the PDF/X file.
@property (copy) NSString *outputConditionId;  // identifier for the output condition
@property PhotoshopPD08 PDFCompatibility;  // PDF version to be compatible with
@property PhotoshopPD01 PDFStandard;  // PDF Standard to be compatible with
@property BOOL preserveEditing;  // Lets you reopen the PDF in Photoshop with native Photoshop data intact
@property (copy) NSString *presetfile;  // preset file to use for settings, may override 'save as' dialog settings
@property BOOL profileInclusionPolicy;  // shows which profiles to include
@property (copy) NSString *registryName;  // URL where the output condition is registered
@property BOOL saveAlphaChannels;  // save alpha channels
@property BOOL saveAnnotations;  // save annotations
@property BOOL saveLayers;  // save layers
@property BOOL saveSpotColors;  // save spot colors
@property NSInteger tileSize;  // compression option supported only with JPEG2000 compression
@property BOOL transparency;  // DEPRECATED, no longer used in CS2
@property BOOL useOutlinesForText;  // DEPRECATED, no longer used in CS2 ( use outlines for text? Only valid if vector data is included )
@property BOOL vectorData;  // DEPRECATED, no longer used in CS2 ( include vector data )
@property BOOL view;  // Opens the saved PDF in Acrobat
@property BOOL webOptimize;  // Improves performance of PDFs on Web servers


@end

// Settings related to saving a Photoshop DCS 1.0 document
@interface PhotoshopPhotoshopDCS10SaveOptions : PhotoshopSaveOptions

@property PhotoshopE340 DCS;  // ( default: color composite )
@property BOOL embedColorProfile;  // embed color profile in document
@property PhotoshopE260 encoding;  // type of encoding to use for document ( default: binary )
@property BOOL halftoneScreen;  // include halftone screen ( default: false )
@property BOOL imageInterpolation;  // use image interpolation ( default: false )
@property PhotoshopE250 previewType;  // type of preview ( default: eight bit Mac OS )
@property BOOL transferFunction;  // include transfer functions in document ( default: false )
@property BOOL vectorData;  // include vector data


@end

// Settings related to saving a Photoshop DCS 2.0 document
@interface PhotoshopPhotoshopDCS20SaveOptions : PhotoshopSaveOptions

@property PhotoshopE340 DCS;  // ( default: no composite PostScript )
@property BOOL embedColorProfile;  // embed color profile in document
@property PhotoshopE260 encoding;  // type of encoding to use for document ( default: binary )
@property BOOL halftoneScreen;  // include halftone screen ( default: false )
@property BOOL imageInterpolation;  // use image interpolation ( default: false )
@property BOOL multifileDCS;  // ( default: false )
@property PhotoshopE250 previewType;  // type of preview ( default: eight bit Mac OS )
@property BOOL saveSpotColors;  // save spot colors
@property BOOL transferFunction;  // include transfer functions in document ( default: false )
@property BOOL vectorData;  // include vector data


@end

// Settings related to saving a Photoshop document
@interface PhotoshopPhotoshopSaveOptions : PhotoshopSaveOptions

@property BOOL embedColorProfile;  // embed color profile in document
@property BOOL saveAlphaChannels;  // save alpha channels
@property BOOL saveAnnotations;  // save annotations
@property BOOL saveLayers;  // save layers
@property BOOL saveSpotColors;  // save spot colors


@end

// Settings related to saving a PICT document
@interface PhotoshopPICTFileSaveOptions : PhotoshopSaveOptions

@property PhotoshopE290 compression;  // ( default: none )
@property BOOL embedColorProfile;  // embed color profile in document
@property PhotoshopE840 resolution;  // number of bits per pixel
@property BOOL saveAlphaChannels;  // save alpha channels


@end

// Settings related to saving a PICT resource file
@interface PhotoshopPICTResourceSaveOptions : PhotoshopSaveOptions

@property PhotoshopE290 compression;  // ( default: none )
@property BOOL embedColorProfile;  // embed color profile in document
@property (copy) NSString *name;  // name of PICT resource ( default: "" )
@property PhotoshopE840 resolution;  // number of bits per pixel
@property NSInteger resourceId;  // ID of PICT resource ( default: 128 )
@property BOOL saveAlphaChannels;  // save alpha channels


@end

// Settings related to saving a Pixar document
@interface PhotoshopPixarSaveOptions : PhotoshopSaveOptions

@property BOOL saveAlphaChannels;  // save alpha channels


@end

// Settings related to saving a PNG document
@interface PhotoshopPNGSaveOptions : PhotoshopSaveOptions

@property NSInteger compression;  // compression used on the image. ( 0 - 9; default: 0 )
@property BOOL interlaced;  // should rows be interlaced? ( default: false )


@end

// Settings related to saving a document in raw format
@interface PhotoshopRawSaveOptions : PhotoshopSaveOptions

@property BOOL saveAlphaChannels;  // save alpha channels
@property BOOL saveSpotColors;  // save spot colors


@end

// Settings related to saving a document in the SGI RGB format
@interface PhotoshopSGIRGBSaveOptions : PhotoshopSaveOptions

@property BOOL saveAlphaChannels;  // save alpha channels
@property BOOL saveSpotColors;  // save spot colors


@end

// Settings related to saving a Target document
@interface PhotoshopTargaSaveOptions : PhotoshopSaveOptions

@property PhotoshopE845 resolution;  // number of bits per pixel ( default: twenty four )
@property BOOL RLECompression;  // should RLE compression be used? ( default: true )
@property BOOL saveAlphaChannels;  // save alpha channels


@end

// Settings related to saving a TIFF document
@interface PhotoshopTIFFSaveOptions : PhotoshopSaveOptions

@property PhotoshopE330 byteOrder;  // Default value is 'Mac OS' when running on MacOS, and 'IBM PC' when running on a PC
@property BOOL embedColorProfile;  // embed color profile in document
@property PhotoshopE320 imageCompression;  // compression type ( default: none )
@property BOOL interleaveChannels;  // are the channels in the image interleaved? ( default: true )
@property NSInteger JPEGQuality;  // quality of produced image. Only valid for JPEG compressed TIFF documents ( 0 - 12 )
@property PhotoshopE325 layerCompression;  // should only be used when you are saving layers
@property BOOL saveAlphaChannels;  // save alpha channels
@property BOOL saveAnnotations;  // save annotations
@property BOOL saveImagePyramid;  // ( default: false )
@property BOOL saveLayers;  // save layers
@property BOOL saveSpotColors;  // save spot colors
@property BOOL transparency;


@end



/*
 * Export Formats Suite
 */

// used with options on the export command
@interface PhotoshopExportOptions : SBObject

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Settings related to exporting Illustrator paths
@interface PhotoshopIllustratorPathsExportOptions : PhotoshopExportOptions

@property (copy) NSString *pathName;  // name of path to export. Only valid if you are exporting a named path
@property PhotoshopE650 targetPath;  // which path to export ( default: document bounds )


@end

// Settings related to exporting Save For Web files
@interface PhotoshopSaveForWebExportOptions : PhotoshopExportOptions

@property double blur;  // apply blur to image to reduce artifacts ( default: 0.0 )
@property PhotoshopCR38 colorReduction;  // color reduction algorithm ( default: selective )
@property NSInteger colorsInPalette;  // number of colors in palette ( default: 256 )
@property PhotoshopE230 dither;  // type of dither ( default: diffusion )
@property NSInteger ditherAmount;  // amount of dither. Only valid for diffusion ( default: 100 )
@property BOOL interlaced;  // download in multiple passes, progressive ( default: false )
@property NSInteger lossy;  // controls amount of lossiness allowed ( default: 0 )
@property (copy) PhotoshopRGBColor *matte;  // defines colors to blend transparent pixels against
@property BOOL optimizedSize;  // creates smaller but less compatible files ( default: true )
@property BOOL pngEight;  // if the format is PNG how many bits, true = 8, false = 24 ( default: true )
@property NSInteger quality;  // quality of produced image ( default: 60 )
@property BOOL transparency;  // ( default: true )
@property NSInteger transparencyAmount;  // amount of transparency dither ( default: 100 )
@property PhotoshopE230 transparencyDither;  // transparency dither algorithm ( default: none )
@property PhotoshopSvFm webFormat;  // File format to use.  Note: Save For Web only supports Compuserve GIF, JPEG, PNG-8, PNG-24, and BMP formats. ( default: CompuServe GIF )
@property NSInteger webSnap;  // snaps close colors to web palette based on tolerance ( default: 0 )
@property BOOL withProfile;  // include an ICC profile based on Photoshop color compensation ( default: false )


@end



/*
 * Filter Suite
 */

// options used with the filter method
@interface PhotoshopFilterOptions : SBObject

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// apply the add noise filter
@interface PhotoshopAddNoise : PhotoshopFilterOptions

@property double amount;
@property PhotoshopE745 distribution;
@property BOOL monochromatic;


@end

// apply the average filter
@interface PhotoshopAverage : PhotoshopFilterOptions


@end

// apply the blur filter
@interface PhotoshopBlur : PhotoshopFilterOptions


@end

// apply the blur more filter
@interface PhotoshopBlurMore : PhotoshopFilterOptions


@end

// apply the clouds filter
@interface PhotoshopClouds : PhotoshopFilterOptions


@end

// apply the custom filter
@interface PhotoshopCustomFilter : PhotoshopFilterOptions

@property (copy) NSArray *characteristics;  // filter characteristics (array of 25 values - Correspons to a left to right, top to bottom traversal of array presented in the Ui)
@property NSInteger scaling;
@property NSInteger offset;


@end

// apply the de-interlace filter
@interface PhotoshopDeinterlace : PhotoshopFilterOptions

@property PhotoshopE755 eliminate;
@property PhotoshopE760 createNewFieldsBy;


@end

// apply the despeckle filter
@interface PhotoshopDespeckle : PhotoshopFilterOptions


@end

// apply the difference clouds filter
@interface PhotoshopDifferenceClouds : PhotoshopFilterOptions


@end

// apply the diffuse glow filter
@interface PhotoshopDiffuseGlow : PhotoshopFilterOptions

@property NSInteger graininess;  // (range: 0 - 10)
@property NSInteger glowAmount;  // (range: 0 - 20)
@property NSInteger clearAmount;  // (range: 0 - 20)


@end

// apply the displace filter
@interface PhotoshopDisplaceFilter : PhotoshopFilterOptions

@property NSInteger horizontalScale;
@property NSInteger verticalScale;
@property PhotoshopE725 kind;
@property PhotoshopE715 undefinedAreas;
@property (copy) NSURL *displacementMapDefinition;


@end

// apply the dust and scratches filter
@interface PhotoshopDustAndScratches : PhotoshopFilterOptions

@property NSInteger radius;  // in pixels
@property NSInteger threshold;


@end

// apply the gaussian blur filter
@interface PhotoshopGaussianBlur : PhotoshopFilterOptions

@property double radius;  // in pixels


@end

// apply the glass filter
@interface PhotoshopGlassFilter : PhotoshopFilterOptions

@property NSInteger distortion;  // (range: 0 - 20)
@property NSInteger smoothness;  // (range: 1 - 15)
@property NSInteger scaling;  // (range: 50 - 200)
@property BOOL invertTexture;  // (default: false )
@property PhotoshopE690 textureKind;
@property (copy) NSURL *textureDefinition;


@end

// apply the high pass filter
@interface PhotoshopHighPass : PhotoshopFilterOptions

@property double radius;  // in pixels


@end

// apply the lens blur filter
@interface PhotoshopLensBlur : PhotoshopFilterOptions

@property PhotoshopLB00 source;  // source for the depth map (default: none )
@property NSInteger focalDistance;  // blur focal distance for the depth map (default: 0 )
@property BOOL invertDepthMap;  // invert the depth map (default: false )
@property PhotoshopLB03 irisShape;  // shape of the iris (default: hexagon )
@property NSInteger radius;  // radius of the iris (default: 15 )
@property NSInteger bladeCurvature;  // blade curvature of the iris (default: 0 )
@property NSInteger rotation;  // rotation of the iris (default: 0 )
@property NSInteger brightness;  // brightness for the specular highlights (default: 0 )
@property NSInteger threshold;  // threshold for the specular highlights (default: 0 )
@property NSInteger amount;  // amount of noise (default: 0 )
@property PhotoshopE745 distribution;  // distribution value for the noise (default: uniform )
@property BOOL monochromatic;  // is the noise monochromatic (default: false )


@end

// apply the lens flare filter
@interface PhotoshopLensFlare : PhotoshopFilterOptions

@property NSInteger brightness;  // (range: 10 - 300)
@property (copy) NSArray *flareCenter;  // position (unit value)
@property PhotoshopE750 lensType;


@end

// apply the maximum filter
@interface PhotoshopMaximumFilter : PhotoshopFilterOptions

@property double radius;  // in pixels


@end

// apply the median noise filter
@interface PhotoshopMedianNoise : PhotoshopFilterOptions

@property double radius;  // in pixels


@end

// apply the minimum filter
@interface PhotoshopMinimumFilter : PhotoshopFilterOptions

@property double radius;  // in pixels


@end

// apply the motion blur filter
@interface PhotoshopMotionBlur : PhotoshopFilterOptions

@property NSInteger angle;
@property double radius;  // in pixels


@end

// apply the NTSC colors filter
@interface PhotoshopNTSCColors : PhotoshopFilterOptions


@end

// apply the ocean ripple filter
@interface PhotoshopOceanRipple : PhotoshopFilterOptions

@property NSInteger rippleSize;  // (range: 1 - 15)
@property NSInteger rippleMagnitude;  // (range: 0 - 20)


@end

// apply the offset filter
@interface PhotoshopOffsetFilter : PhotoshopFilterOptions

@property double horizontalOffset;  // (unit value)
@property double verticalOffset;  // (unit value)
@property PhotoshopE718 undefinedAreas;


@end

// apply the pinch filter
@interface PhotoshopPinch : PhotoshopFilterOptions

@property NSInteger amount;  // (range: -100 - 100)


@end

// apply the polar coordinates filter
@interface PhotoshopPolarCoordinates : PhotoshopFilterOptions

@property PhotoshopE700 kind;


@end

// apply the radial blur filter
@interface PhotoshopRadialBlur : PhotoshopFilterOptions

@property NSInteger amount;  // from 0 to 100
@property PhotoshopE670 blurMethod;
@property PhotoshopE675 quality;


@end

// apply the ripple filter
@interface PhotoshopRipple : PhotoshopFilterOptions

@property NSInteger amount;  // (range: -999 - 999)
@property PhotoshopE710 rippleSize;


@end

// apply the sharpen filter
@interface PhotoshopSharpen : PhotoshopFilterOptions


@end

// apply the sharpen edges filter
@interface PhotoshopSharpenEdges : PhotoshopFilterOptions


@end

// apply the sharpen more filter
@interface PhotoshopSharpenMore : PhotoshopFilterOptions


@end

// apply the shear filter
@interface PhotoshopShear : PhotoshopFilterOptions

@property (copy) NSArray *curve;  // specification of shear curve. List of curve points
@property PhotoshopE715 undefinedAreas;


@end

// apply the smart blur filter
@interface PhotoshopSmartBlur : PhotoshopFilterOptions

@property double radius;  // radius (range: 0 - 1000)
@property double threshold;  // threshold (range: 0 - 1000)
@property PhotoshopE680 quality;
@property PhotoshopE685 mode;


@end

// apply the spherize filter
@interface PhotoshopSpherize : PhotoshopFilterOptions

@property NSInteger amount;  // (range: -100 - 100)
@property PhotoshopE720 mode;


@end

// apply the texture fill filter
@interface PhotoshopTextureFill : PhotoshopFilterOptions

@property (copy) NSURL *filePath;  // texture file. Must be a grayscale Photoshop file


@end

// apply the twirl filter
@interface PhotoshopTwirl : PhotoshopFilterOptions

@property NSInteger angle;  // (range: -999 - 999)


@end

// apply the unsharp mask filter
@interface PhotoshopUnsharpMask : PhotoshopFilterOptions

@property double amount;
@property double radius;  // in pixels
@property NSInteger threshold;  // threshold


@end

// apply the wave filter
@interface PhotoshopWaveFilter : PhotoshopFilterOptions

@property NSInteger numberOfGenerators;  // number of generators
@property NSInteger minimumWavelength;
@property NSInteger maximumWavelength;
@property NSInteger minimumAmplitude;
@property NSInteger maximumAmplitude;
@property NSInteger horizontalScale;
@property NSInteger verticalScale;
@property PhotoshopE730 waveType;
@property PhotoshopE715 undefinedAreas;
@property NSInteger randomSeed;


@end

// apply the zigzag filter
@interface PhotoshopZigzag : PhotoshopFilterOptions

@property NSInteger amount;  // (range: -100 - 100)
@property NSInteger ridges;
@property PhotoshopE740 style;


@end



/*
 * Adjustment Suite
 */

// options used with the adjust method
@interface PhotoshopAdjustmentOptions : SBObject

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// adjust contrast of the selected channels automatically
@interface PhotoshopAutomaticContrast : PhotoshopAdjustmentOptions


@end

// adjust levels of the selected channels using auto levels option
@interface PhotoshopAutomaticLevels : PhotoshopAdjustmentOptions


@end

// adjust brightness and constrast
@interface PhotoshopBrightnessAndContrast : PhotoshopAdjustmentOptions

@property NSInteger brightnessLevel;
@property NSInteger contrastLevel;


@end

@interface PhotoshopColorBalance : PhotoshopAdjustmentOptions

@property (copy) NSArray *shadows;  // list of adjustments for shadows. There must be 3 values in the list
@property (copy) NSArray *midtones;  // list of adjustments for midtones. There must be 3 values in the list
@property (copy) NSArray *highlights;  // list of adjustments for highlights. There must be 3 values in the list
@property BOOL preserveLuminosity;


@end

// adjust curves of the selected channels
@interface PhotoshopCurves : PhotoshopAdjustmentOptions

@property (copy) NSArray *curvePoints;  // list of curve points (number of points must be between 2 and 14)


@end

@interface PhotoshopDesaturate : PhotoshopAdjustmentOptions


@end

// equalize the levels
@interface PhotoshopEqualize : PhotoshopAdjustmentOptions


@end

// inverts the currently selected layer or channels
@interface PhotoshopInversion : PhotoshopAdjustmentOptions


@end

// adjust levels of the selected channels
@interface PhotoshopLevelsAdjustment : PhotoshopAdjustmentOptions

@property NSInteger inputRangeStart;
@property NSInteger inputRangeEnd;
@property double inputRangeGamma;
@property NSInteger outputRangeStart;
@property NSInteger outputRangeEnd;


@end

// only valid for RGB or CMYK documents
@interface PhotoshopMixChannels : PhotoshopAdjustmentOptions

@property (copy) NSArray *outputChannels;  // list of channel specifications. For each component channel that the document has, you must specify a list of adjustment values followed by a 'constant' value
@property BOOL monochromeMixing;  // use monochrome mixing? If this is true you can only specify one channel value (default: false )


@end

@interface PhotoshopPhotoFilter : PhotoshopAdjustmentOptions

@property (copy) PhotoshopColorValue *withContents;  // a color to use for the fill
@property NSInteger density;  // density of the filter effect as a percent (default: 25 )
@property BOOL preserveLuminosity;  // (default: true )


@end

@interface PhotoshopPosterize : PhotoshopAdjustmentOptions

@property NSInteger levels;


@end

@interface PhotoshopSelectiveColor : PhotoshopAdjustmentOptions

@property PhotoshopE890 selectionMethod;
@property (copy) NSArray *reds;  // Array of 4 values: cyan, magenta, yellow, black
@property (copy) NSArray *yellows;  // Array of 4 values: cyan, magenta, yellow, black
@property (copy) NSArray *greens;  // Array of 4 values: cyan, magenta, yellow, black
@property (copy) NSArray *cyans;  // Array of 4 values: cyan, magenta, yellow, black
@property (copy) NSArray *blues;  // Array of 4 values: cyan, magenta, yellow, black
@property (copy) NSArray *magentas;  // Array of 4 values: cyan, magenta, yellow, black
@property (copy) NSArray *whites;  // Array of 4 values: cyan, magenta, yellow, black
@property (copy) NSArray *neutrals;  // Array of 4 values: cyan, magenta, yellow, black
@property (copy) NSArray *blacks;  // Array of 4 values: cyan, magenta, yellow, black


@end

@interface PhotoshopShadowHighlight : PhotoshopAdjustmentOptions

@property NSInteger shadowAmount;  // percentage from 0 to 100 (default: 50 )
@property NSInteger shadowWidth;  // percentage from 0 to 100 for tonal width (0 = narrow), (100 = broad) (default: 50 )
@property NSInteger shadowRadius;  // pixel amount from 0 to 2500 (default: 30 )
@property NSInteger highlightAmount;  // percentage from 0 to 100 (default: 0 )
@property NSInteger highlightWidth;  // percentage from 0 to 100 for tonal width (0 = narrow), (100 = broad) (default: 50 )
@property NSInteger highlightRadius;  // pixel amount from 0 to 2500 (default: 30 )
@property NSInteger colorCorrection;  // adjust the colors in the changed portion of the image (-100 to 100) (default: 20 )
@property NSInteger midtoneContrast;  // amount for the midtone contrast (-100 to 100) (default: 0 )
@property double blackClip;  // fractions of whites to be clipped (default: 0.01 )
@property double whiteClip;  // fractions of blacks to be clipped (default: 0.01 )


@end

@interface PhotoshopThresholdAdjustment : PhotoshopAdjustmentOptions

@property NSInteger level;


@end



/*
 * Color Suite
 */

// A color value
@interface PhotoshopColorValue : SBObject

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (PhotoshopColorValue *) convertColorTo:(PhotoshopE930)to;  // convert a object from one color model to another
- (BOOL) equalColorsWith:(PhotoshopColorValue *)with;  // are the colors visually equal?

@end

// A CMYK color specification
@interface PhotoshopCMYKColor : PhotoshopColorValue

@property double cyan;  // the cyan color value (between 0.0 and 100.0)
@property double magenta;  // the magenta color value (between 0.0 and 100.0)
@property double yellow;  // the yellow color value (between 0.0 and 100.0)
@property double black;  // the black color value (between 0.0 and 100.0)


@end

// A gray color specification
@interface PhotoshopGrayColor : PhotoshopColorValue

@property double grayValue;  // the gray value ( 0.0 - 100.0; default: 0.0 )


@end

// An HSB color specification
@interface PhotoshopHSBColor : PhotoshopColorValue

@property double hue;  // the hue value (between 0.0 and 360.0)
@property double saturation;  // the saturation value (between 0.0 and 100.0)
@property double brightness;  // the brightness value (between 0.0 and 100.0)


@end

// An Lab color specification
@interface PhotoshopLabColor : PhotoshopColorValue

@property double value_L;  // the L-value (between 0.0 and 100.0)
@property double value_a;  // the a-value (between -128.0 and 127.0)
@property double value_b;  // the b-value (between -128.0 and 127.0)


@end

// represents a missing color
@interface PhotoshopNoColor : PhotoshopColorValue


@end

// An RGB color specification
@interface PhotoshopRGBColor : PhotoshopColorValue

@property double red;  // the red color value ( 0.0 - 255.0; default: 255.0 )
@property double green;  // the green color value ( 0.0 - 255.0; default: 255.0 )
@property double blue;  // the blue color value ( 0.0 - 255.0; default: 255.0 )


@end

// A hexadecimal specification of an RGB color
@interface PhotoshopRGBHexColor : PhotoshopColorValue

@property (copy) NSString *hexValue;  // the hex representation of the color. (Example '10FF4B')


@end



/*
 * Path Suite
 */

// An artwork path item
@interface PhotoshopPathItem : SBObject

- (SBElementArray *) subPathItems;

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (readonly) NSInteger index;  // the index of this instance of the object
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy, readonly) SBObject *container;  // the object's container
@property (copy, readonly) NSArray *entirePath;  // all the path item's sub paths
@property PhotoshopPT21 kind;
@property (copy) NSString *name;  // the name of the path item

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location
- (void) createSelectionFeatherAmount:(double)featherAmount antialiasing:(BOOL)antialiasing operation:(PhotoshopE630)operation;  // make a selection from this path
- (void) deselect;  // unselect this path item, no paths items are selected
- (void) fillPathWithContents:(id)withContents blendMode:(PhotoshopE925)blendMode opacity:(double)opacity preservingTransparency:(BOOL)preservingTransparency featherAmount:(double)featherAmount antialiasing:(BOOL)antialiasing wholePath:(BOOL)wholePath;  // fill the path with the following information
- (void) makeClippingPathFlatness:(double)flatness;  // make this path item the clipping path for this document
- (void) select;  // make this path item the active or selected path item
- (void) strokePathTool:(PhotoshopPT23)tool simulatePressure:(BOOL)simulatePressure;  // stroke the path with the following information

@end

// A point on a path
@interface PhotoshopPathPoint : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (readonly) NSInteger index;  // the index of this instance of the object
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy, readonly) NSArray *anchor;  // the position (coordinates) of the anchor point
@property (copy, readonly) SBObject *container;  // the object's container
@property (readonly) PhotoshopPT22 kind;  // the type of point: smooth/corner
@property (copy, readonly) NSArray *leftDirection;  // location of the left direction point (in position)
@property (copy, readonly) NSArray *rightDirection;  // location of the right direction point (out position)

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Path point information (returned by entire path dataClassProperty of path item class)
@interface PhotoshopPathPointInfo : SBObject

@property (copy) NSArray *anchor;  // the position of the anchor (in coordinates)
@property PhotoshopPT22 kind;  // the point type, smooth/corner
@property (copy) NSArray *leftDirection;  // location of the left direction point (in position)
@property (copy) NSArray *rightDirection;  // location of the right direction point (out position)

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// Sub path information (returned by entire path dataClassProperty of path item class)
@interface PhotoshopSubPathInfo : SBObject

@property BOOL closed;  // is this path closed?
@property (copy) NSArray *entireSubPath;  // all the sub path item's path points
@property PhotoshopPT45 operation;  // sub path operation on other sub paths

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

// An artwork sub path item
@interface PhotoshopSubPathItem : SBObject

- (SBElementArray *) pathPoints;

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (readonly) NSInteger index;  // the index of this instance of the object
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (readonly) BOOL closed;  // is this path closed?
@property (copy, readonly) SBObject *container;  // the object's container
@property (copy, readonly) NSArray *entireSubPath;  // all the sub path item's path points
@property (readonly) PhotoshopPT45 operation;  // sub path operation on other sub paths

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end



/*
 * Notifier Suite
 */

// The parameters of the notifie
@interface PhotoshopNotifier : SBObject

@property (copy, readonly) NSNumber *bestType;  // the best type for the object's value
@property (copy, readonly) NSNumber *defaultType;  // the default type for the object's value
@property (readonly) NSInteger index;  // the index of this instance of the object
@property (copy) NSDictionary *properties;  // all of this object's properties returned in a single record
@property (copy, readonly) NSString *event;  // The id of the event, four characters or a unique string
@property (copy, readonly) NSString *eventClass;  // The class id the event applies to, four characters or a unique string. Allows you to distinguish between the same event applied to different classes.
@property (copy, readonly) NSURL *eventFile;  // The file to execute when the event occurs

- (void) delete;  // Remove an element from an object
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Duplicate one or more object(s)
- (BOOL) exists;  // Verify if an object exists
- (SBObject *) moveTo:(SBObject *)to;  // Move object(s) to a new location

@end

