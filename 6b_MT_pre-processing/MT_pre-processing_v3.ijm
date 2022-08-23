/*
 * The macro allows to unmix colors in image of samples stained with Masson's trichrome.
 * The plugin "Colour Deconvolution" is required.
 * The present file must be copied to the "plugins" folder of ImageJ/Fiji.
 */

//Integration to ImageJ/Fiji menu
macro"MT_pre-processing"{

//Preparation of duplicate image
Title = File.nameWithoutExtension;
run("Select All");
run("Duplicate...", "title=[Duplicate]");
close(Title);

//Color unmixing in Masson's trichrome staining
run("Colour Deconvolution", "vectors=[Masson Trichrome]");

//About connective tissue
selectWindow("Duplicate-(Colour_1)");
run("RGB Color");
rename(Title + "_connective");
saveAs("Tiff");

//About cytoplasm
selectWindow("Duplicate-(Colour_2)");
run("RGB Color");
rename(Title + "_cytoplasm");
saveAs("Tiff");

//About nuclei
selectWindow("Duplicate-(Colour_3)");
run("RGB Color");
rename(Title + "_nuclei");
saveAs("Tiff");

//Close all image windows
close("*");

//END
}