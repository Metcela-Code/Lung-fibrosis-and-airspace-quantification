/*
 * The macro allows to detect fibrosis in the sample.
 * The macro can be applied to SR- or MT-stained samples.
 * The present file must be copied to the "plugins" folder of ImageJ/Fiji.
 */

//Integration to ImageJ/Fiji menu
macro"Fibrosis_detection"{

//Input image name
Title = File.nameWithoutExtension;
rename(Title);
run("Select All");

//Scaling
//Initialization
px = 1;
um = 1;
//Scaling dialog
Dialog.create("Image scaling");
Dialog.addNumber("Distance (px):", px);
Dialog.addNumber("Known distance (um):", um);
Dialog.show();

//Update	
px = Dialog.getNumber();
um = Dialog.getNumber();
run("Set Scale...", "distance=px known=um unit=um");

//Preparation of duplicate image and extraction of green channel

//Separation of RGB channels
selectWindow(Title);
run("Split Channels");
//About red channel
selectWindow(Title + " (red)");
run("Duplicate...", "title=[R_1]");
close(Title + " (red)");

//About green channel
selectWindow(Title + " (green)");
run("Duplicate...", "title=[G_1]");
run("Duplicate...", "title=[G]");
close(Title + " (green)");
//About blue channel
selectWindow(Title + " (blue)");
run("Duplicate...", "title=[B_1]");
close(Title + " (blue)");
//Assembly of image dulpicate
run("Merge Channels...", "red=[R_1] green=[G_1] blue=[B_1] gray=*None* create");
run("RGB Color");
selectWindow("Composite (RGB)");
rename(Title + "_duplicate");
close("Composite");

//Definition of lower and upper values of autothreshold
selectWindow("G");
setAutoThreshold();
getThreshold(auto_lower, auto_upper);
run("Set Measurements...", "area perimeter limit display redirect=None decimal=3");

//Manual threshold setting dialog
//Initialization
confirm = false;
auto = false;
current_lower = auto_lower;
current_upper = auto_upper;
test = 0;

//Update
	while (confirm == false) {

	//Reset
		if (auto == true) {
			close("Sample");
			close("Mask of Sample");
			close("Duplicate_1");
			close("Overlay_fibrosis");
			close("Results");
			close("Summary");
			close("ROI Manager");
			current_lower = auto_lower;
			current_upper = auto_upper;
			test=0;
		}

	//Deletion of intermediate files
		if (test != 0) {
			close("Sample");
			close("Mask of Sample");
			close("Duplicate_1");
			close("Overlay_fibrosis");
			close("Results");
			close("Summary");
			close("ROI Manager");
		}
		
	//Particles measurements
		selectWindow("G");
		run("Duplicate...", "title=[Sample]");
		selectWindow("Sample");
		setThreshold(current_lower, current_upper);
		run("Convert to Mask");
		run("Make Binary");
		run("Analyze Particles...", "size=0-Infinity show=Masks display clear summarize add");

	//Visualization
		selectWindow(Title + "_duplicate");
		run("Duplicate...", "title=[Duplicate_1]");
		selectWindow("Mask of Sample");
		run("Create Selection");
		roiManager("Add");
		roiManager("Select", roiManager("Count") - 1);
		roiManager("Rename", "Fibrosis");
		roiManager("Set Fill Color", "red");
		roiManager("Show All without labels");
		selectWindow("Duplicate_1");
		run("From ROI Manager");
		run("Flatten");
		//Legend
			setColor("red");
			x = 0; y = 50;
			setFont("SansSerif", 50, "antiliased");
			drawString("Fibrosis", x, y, "black");
		selectWindow("Duplicate_1-1");
		rename("Overlay_fibrosis");
		
	//Threshold dialog
		ParticlesCount = roiManager("Count") - 1;
		Dialog.create("Detection of fibrosis");
		Dialog.addString("Applies to:", Title);
		Dialog.addString("Test #:", test);
		Dialog.addString("Particles count:", ParticlesCount);
		Dialog.addMessage("Threshold parameters (0~255):");
		Dialog.addNumber("Lower value:", current_lower);
		Dialog.addNumber("Upper value:", current_upper);
		options = newArray("Test settings", "Confirm settings", "Reset (autothreshold: " + auto_lower + ", " + auto_upper + ")");
		Dialog.addRadioButtonGroup("Options:", options, 3, 1, "Test settings");
		Dialog.show();
		
	//Values update
		test = test + 1;
		current_lower = Dialog.getNumber();
		if (current_lower < 0) {
			current_lower = auto_lower;
		}
		if (current_lower > 255) {
			current_lower = auto_lower;
		}		
		current_upper = Dialog.getNumber();
		if (current_upper < 0) {
			current_upper = auto_upper;
		}
		if (current_upper > 255) {
			current_upper = auto_upper;
		}		
		select = Dialog.getRadioButton();
		if (select == "Test settings") {
			confirm = false;
			auto = false;
		}
		if (select == "Confirm settings") {
			confirm = true;		
			auto = false;		
		}
		if (select == "Reset (autothreshold: " + auto_lower + ", " + auto_upper + ")"){
			confirm = false;
			auto = true;
		}

	}

//Output
	//Save dialog
		Dialog.create("Save output files");
		Dialog.addCheckbox("Save?", false);
		Dialog.show();	
	
		save_output = Dialog.getCheckbox();
			if (save_output == true) {
				//Mask
				selectWindow("Mask of Sample");
				rename("Mask_fibrosis");
				roiManager("Show All without labels");
				saveAs("Tiff");
				//Overlay
				selectWindow("Overlay_fibrosis");
				saveAs("Tiff", File.getDefaultDir + "Overlay_fibrosis.tif");
				//ROI
				selectWindow("ROI Manager");
				roiManager("save", File.getDefaultDir + "ROI_set_fibrosis.zip");
				run("Close");
				//Results
				selectWindow("Results");
				saveAs("Results", File.getDefaultDir + "Results.csv");
				run("Close");
				//Summary
				selectWindow("Summary");
				saveAs("Results", File.getDefaultDir + "Summary.csv");
				run("Close");
				//Settings
				print("Analysis of: " + Title + " (green channel)");
				print("Scale: " + px + " px / " + um + " um");
				print("Lower threshold: " + current_lower);
				print("Upper threshold: " + current_upper);
				print("Number of particles: " + ParticlesCount);
				selectWindow("Log");
				saveAs("Text", File.getDefaultDir + "Settings.txt");
				run("Close");
			}

//Close all windows dialog
	Dialog.create("End of analysis");
	Dialog.addCheckbox("Close all windows?", false);
	Dialog.show();
	
	close_all = Dialog.getCheckbox();
		if (close_all == true) {
			close("*");
		}

//END
}
