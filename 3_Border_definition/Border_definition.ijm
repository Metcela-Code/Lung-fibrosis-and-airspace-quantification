/*
 * The macro allows to define the border of the sample.
 * The macro can be applied to any binary image.
 * The present file must be copied to the "plugins" folder of ImageJ/Fiji.
 */

//Integration to ImageJ/Fiji menu
macro"Border_definition"{

//Input image name
Title = File.nameWithoutExtension;
rename(Title);
run("Select All");

//Duplication of image
selectWindow(Title);
run("Duplicate...", "title=[Mask]");
close(Title);

//Sample correction dialog
//Initialization
confirm_correct = false;
test = 0;
selectWindow("Mask");
run("Duplicate...", "title=[Mask_corrected]");
selectWindow("Mask_corrected");
run("Fill Holes");

//Correction
	while (confirm_correct == false) {

	//New correction
			//Correction of breaks dialog
				selectWindow("Mask_corrected");
				waitForUser("Repair breaks using pencil or paintbrush tools");
				run("Select All");
			//Identification of breaks
				selectWindow("Mask_corrected");
				run("Fill Holes");
		
		//End of correction
			Dialog.create("Validation of sample");
			Dialog.addString("Applies to:", Title);
			Dialog.addString("test #:", test);
			options = newArray("Continue correction", "Confirm correction");
			Dialog.addRadioButtonGroup("Options:", options, 2, 1, "Continue correction");
			Dialog.show();

		//Values update
			test = test + 1;
			select = Dialog.getRadioButton();
			if (select == "Continue correction") {
				confirm_correct = false;
			}
			if (select == "Confirm correction") {
				confirm_correct = true;
			}

	}

//Duplication of corrected image
selectWindow("Mask_corrected");
run("Duplicate...", "title=[Mask_corrected_1]");
run("Duplicate...", "title=[Mask_corrected_2]");

//Definition of default analysis parameters
default_thick = 10;

//Border thickness setting dialog
//Initialization
confirm = false;
auto = false;
current_thick = - default_thick;
test = 0;

//Update
	while (confirm == false) {

		//Reset
			if (auto == true) {
				close("Mask_corrected_2_border");
				close("Mask_corrected_1_duplicate");
				close("Overlay_border");
				close("ROI Manager");
				current_thick = - default_thick;
				test = 0;
			}

		//Deletion of intermediate files
			if (test != 0) {
				close("Mask_corrected_2_border");
				close("Mask_corrected_1_duplicate");
				close("Overlay_border");
				close("ROI Manager");
			}

		//Definition of border
			selectWindow("Mask_corrected_2");
			run("Duplicate...", "title=[Mask_corrected_2_border]");
			selectWindow("Mask_corrected_2_border");
			run("Fill Holes");
			run("Create Selection");
			run("Enlarge...", "enlarge=current_thick");
			run("Clear", "slice");
			run("Convert to Mask");
			run("Create Selection");
			roiManager("Add");

		//Visualization
			selectWindow("Mask_corrected_1");
			run("Duplicate...", "title=[Mask_corrected_1_duplicate]");
			selectWindow("Mask_corrected_2_border");
			run("Create Selection");
			roiManager("Add");
			roiManager("Select", roiManager("Count") - 1);
			roiManager("Rename", "Border");
//			RoiManager.setGroup(0);
//			RoiManager.setPosition(0);			
			roiManager("Set Fill Color", "green");
			roiManager("Show All without labels");
			selectWindow("Mask_corrected_1_duplicate");
			run("From ROI Manager");
			run("Flatten");
			//Legend
				setColor("green");
				x = 0; y = 50;
				setFont("SansSerif", 50, "antiliased");
				drawString("Border", x, y, "black");
			selectWindow("Mask_corrected_1_duplicate-1");
			rename("Overlay_border");

		//Border dialog
			Dialog.create("Definition of border thickness");
			Dialog.addString("Applies to:", Title);
			Dialog.addString("test #:", test);
			Dialog.addNumber("Border thickness (um):", - current_thick);
			options = newArray("Test settings", "Confirm settings", "Reset (default: " + default_thick + " um)");
			Dialog.addRadioButtonGroup("Options:", options, 3, 1, "Test settings");
			Dialog.show();

		//Values update
			test = test + 1;
			current_thick = Dialog.getNumber();
			if (current_thick >= 0) {
				current_thick = - current_thick;
			}
			if (current_thick < 0) {
				current_thick = current_thick;
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
			if (select == "Reset (default: "+default_thick+" um)") {
				confirm = false;
				auto = true;
			}

	}

//Ouput
	//Save dialog
	Dialog.create("Save output files");
	Dialog.addCheckbox("Save?", false);
	Dialog.show();
	
	save_output = Dialog.getCheckbox();
		if (save_output == true) {
		
			//Mask
			selectWindow("Mask_corrected_2_border");
			rename("Mask_border");
			roiManager("Show All without labels");
			saveAs("Tiff");
			//Overlay
			selectWindow("Overlay_border");
			saveAs("Tiff", File.getDefaultDir + "Overlay_border.tif");
			//ROI
			selectWindow("ROI Manager");
			roiManager("save", File.getDefaultDir + "ROI_set_border.zip");
			run("Close");
			//Settings
			print("Analysis of: "+Title);
			print("Border thickness: " + - current_thick + " um");
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
