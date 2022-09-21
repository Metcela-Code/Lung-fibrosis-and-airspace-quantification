/*
 * The macro allows to identify air ducts in the sample.
 * The macro can be applied to any binary image.
 * The present file must be copied to the "plugins" folder of ImageJ/Fiji.
 */

//Integration to ImageJ/Fiji menu
macro"Air_ducts_identification"{

//Input image name
Title = File.nameWithoutExtension;
rename(Title);
run("Select All");

//Duplication of image
selectWindow(Title);
run("Duplicate...", "title=[Mask]");
close(Title);

//Air duct identification dialog
//Initialization
add = false;
delete = false;
confirm = false;
AirDuctsCount = 0;
	
//Update
	while (confirm == false) {

		//Air ducts count update
			if (roiManager("Count") == 0) {
				AirDuctsCount = 0;
			}
			if (roiManager("Count") == 1) {
				AirDuctsCount = 1;
			}
			if (roiManager("Count") > 1) {
				AirDuctsCount = roiManager("Count") - 1;
			}

		//Air ducts dialog
			Dialog.create("Identification of air ducts");
			Dialog.addString("Applies to:", Title);
			Dialog.addString("Number of air ducts:", AirDuctsCount);
			options = newArray("Add new air duct", "Delete last air duct", "Confirm selection");
			Dialog.addRadioButtonGroup("Options:", options, 3, 1, "Add new air duct");
			Dialog.show();
		
		//Input update
			select = Dialog.getRadioButton();
			if (select == "Add new air duct") {
				add = true;
				delete = false;
				confirm = false;
			}
			if (select == "Delete last air duct") {
				add = false;
				delete = true;
				confirm = false;
			}
			if (select == "Confirm selection") {
				add = false;
				delete = false;
				confirm = true;
			}
		
		//Add
			if (add == true) {
				if (roiManager("Count") >= 2) {
					//Deletion of ROI combination
					roiManager("Select", roiManager("Count") - 1);
					roiManager("Delete");
					//Addition of new ROI
					waitForUser("Identify new air duct");
					roiManager("Add");
				} else {
					waitForUser("Identify new air duct");
					roiManager("Add");
				}
			}

		//Delete
			if (delete == true) {
				if (roiManager("Count") >= 2) {
					//Deletion of ROI combination
					roiManager("Select", roiManager("Count") - 1);
					roiManager("Delete");
					//Deletion of last ROI
					roiManager("Select", roiManager("Count") - 1);
					roiManager("Delete");
					} else {
						print("No ROI");
					}
			}

		//Assembly of current ROI
			if (roiManager("Count") >= 1){
				CurrentROI = newArray(roiManager("Count"));
					for (i = 0; i < roiManager("Count"); i += 1) {
						CurrentROI[i] = i;
					}
				roiManager("Select", CurrentROI);
				roiManager("Combine");
				roiManager("Add");
				roiManager("Select", roiManager("Count") - 1);
				roiManager("Rename", "Air_ducts");
				roiManager("Set Fill Color", "cyan");
			}

	}

//Visualization
	selectWindow("Mask");
	roiManager("Select", "Air_Ducts");
	roiManager("Show All without labels");
	run("From ROI Manager");
	run("Flatten");
	//Legend
		setColor("cyan");
		x = 0; y = 50;
		setFont("SansSerif", 50, "antiliased");
		drawString("Air ducts", x, y, "black");
	selectWindow("Mask-1");
	rename("Overlay_air_ducts");

//Ouput
	//Save dialog
	Dialog.create("Save output files");
	Dialog.addCheckbox("Save?", false);
	Dialog.show();

	save_output = Dialog.getCheckbox();
		if (save_output == true) {
			//Overlay
			selectWindow("Overlay_air_ducts");
			saveAs("Tiff");
			//ROI
			selectWindow("ROI Manager");
				//Correction of ROI manager content: deletion of "Air_ducts-1")
				roiManager("Select", roiManager("Count") - 1);
				roiManager("Delete");
			roiManager("save", File.getDefaultDir+"ROI_set_air_ducts.zip");
			run("Close");
		}

//Close all windows dialog
	Dialog.create("End of analysis");
	Dialog.addCheckbox("Close all windows?", false);
	Dialog.show();

	close_all = Dialog.getCheckbox();
		if (close_all == true){
			close("*");
		}

//END
}
