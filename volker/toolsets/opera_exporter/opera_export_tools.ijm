/*
   MRI Opera export tools
  
   The tool stitches images from the Opera Phenix HCS System.
   It reads the ``Index.idx.xml`` file to pre-arrange the images and then
   stitches and fuses them using the ``Grid/Collection stitching``-plugin.

   Images are stitched by plane and channel. Z-stacks and multi-channel images can
   optionally be created. Projections can also be created.
    
   (c) 2021, INSERM
   
   written by Volker Baecker at Montpellier Ressources Imagerie, Biocampus Montpellier, INSERM, CNRS, University of Montpellier (www.mri.cnrs.fr)
*/

var helpURL = "https://github.com/MontpellierRessourcesImagerie/imagej_macros_and_scripts/wiki/MRI_Opera_export_tools";
var _OPERA_INDEX_FILE = ""
var _BYTES_TO_READ = 10000;
var _SELECTED_WELLS = newArray(0);
var _WELLS = newArray(0);
var _EXPORT_ALL = true;
var _CREATE_Z_STACK = true;
var _MERGE_CHANNELS = true;
var _DO_MIP = false;
var _ZSLICE = 0;
var _CHANNEL = 1;
var _FUSION_METHODS = newArray("Linear_Blending", "Average", "Median", "Max_Intensity", "Min_Intensity", "random");
var _FUSION_METHOD = "Linear_Blending";
var _REGRESSION_THRESHOLD = 0.30;
var _DISPLACEMENT_THRESHOLD = 2.5;
var _ABS_DISPLACEMENT_THRESHOLD = 3.5;
var _PSEUDO_FLAT_FIELD_RADIUS = 0;
var _ROLLING_BALL_RADIUS = 0;
var _NORMALIZE = false;
var _FIND_AND_SUB_BACK_RADIUS = 0;
var _FIND_AND_SUB_BACK_OFFSET = 3;
var _FIND_AND_SUB_BACK_ITERATIONS = 1;
var _FIND_AND_SUB_BACK_SKIP = 0.3;
var _COLORS = newArray("Red", "Green", "Blue", "Cyan", "Magenta", "Yellow", "Grays");
var _SELECTED_COLORS = newArray("Blue", "Green", "Red", "Cyan", "Magenta", "Yellow", "Grays");

launchExport();
exit();

macro "Opera export tools help (f4) Action Tool - CdedD62CdddD72CdedL8292CeeeLa2b2Ca9aD43C555D53C434L6373C555L8393C666Da3C555Lb3c3C666Dd3Ca9aDe3C888D44C666D54C555D64C434L7494C555Da4C434Db4C666Lc4d4C989De4L4555C877D65C434D75C877D85C555D95C877Da5C555Db5CbbbDc5Ca9aLd5e5C989D46C877D56C666D66C434D76C989D86C877L96a6C666Db6C989Dc6C877Dd6Ca9aDe6CdddL1737Ca9aD47C666L5787C888L97a7C989Lb7d7CdddDe7CdedD08C989L1828CdddL3868CdedL78a8CeeeLb8c8CdedDd8CeeeDe8CdddD09C888L1929CdddD39CdedD49CdddD59CdedL6999CeeeLa9d9CdddD0aC989L1a2aCdddD3aCeeeL4a5aLbacaCdedDdaCeeeDeaCdedD0bC666L1b2bCbbbD3bCdddD4bCbbbL5b7bCa9aD8bC989D9bC888LabbbC666LcbdbCbbbDebCdddD1cC888D2cC666L3c5cC989D6cCa9aD7cCbbbL8c9cCdddDacCdedDbcCeeeDcc"{
	run('URL...', 'url='+helpURL);
}

macro "Opera export tools help [f4]" {
	run('URL...', 'url='+helpURL);
}

macro "Set index file (f5) Action Tool - C666D12C000L2262CaaaD72C444D13C333D23CcccL3353C888D63C000D73C444L83c3C666Dd3C444L1424CaaaD74C444L84b4C333Dc4C000Dd4C444L1525CcccDc5C000Dd5C444L1626L1727CbbbD37C444L47d7C555De7C444L1828C666D38C111D48C444L58c8C111Dd8C555De8C444L1929C222D39C888D49C111Dd9C888De9C444D1aC222D2aC000D3aCcccD4aCdddDcaC000DdaCdddDeaC444D1bC000L2b3bC888DcbC111DdbC444D1cC000D2cC333D3cCcccL4cbcC444DccC555DdcC666D1dC000L2dcdC888Ddd" {
	setIndexFile();
}

macro "set index-file [f5]" {
	setIndexFile();
}

macro "Select wells (f6) Action Tool - C111D22C000L3242CcccL5262C000L7282CcccL92a2C000Lb2c2C111Dd2C000L2343CcccL5363C000L7383CcccL93a3C000Lb3d3L2444CcccL5464C000L7484CcccL94a4C000Lb4d4CcccL2545L7585Lb5d5L2646L7686Lb6d6C000L2747CcccL5767C000L7787CcccL97a7C000Lb7d7L2848CcccL5868C000L7888CcccL98a8C000Lb8d8CcccL2949L7989Lb9d9L2a4aL7a8aLbadaC000L2b4bCcccL5b6bC000L7b8bCcccL9babC000LbbdbL2c4cCcccL5c6cC000L7c8cCcccL9cacC000LbcdcC111D2dC000L3d4dCcccL5d6dC000L7d8dCcccL9dadC000LbdcdC111Ddd" {
	selectWells();	
}

macro "select wells [f6]" {
	selectWells();
}

macro "Set options (f7) Action Tool - CaaaD61C555L7181CaaaD91C222L6292C888D33CcccD43C333D53C111D63CeeeL7383C111D93C333Da3CcccDb3C888Dc3C666D24C000L3444C444D54CcccD64D94C444Da4C000Lb4c4C666Dd4CeeeD15C000D25CbbbD35Dc5C000Dd5CeeeDe5CcccD16C111D26C666D36CbbbD66C333D76C222D86CbbbD96C666Dc6C111Dd6CcccDe6C888D27C111D37C222D67C666D77C444D87C333D97C111Dc7C888Dd7D28C111D38C222D68C555D78C444D88C222D98C111Dc8C888Dd8CcccD19C111D29C666D39CbbbD69C222L7989CbbbD99C666Dc9C111Dd9CcccDe9D1aC000D2aCbbbD3aDcaC000DdaCeeeDeaC444D2bC000L3b4bC444D5bCcccD6bD9bC444DabC000LbbcbC666DdbC888D3cCbbbD4cC222D5cC111D6cCeeeL7c8cC111D9cC222DacCbbbDbcC888DccC222L6d9dCaaaD6eC444L7e8eCaaaD9e" {
	setOptions();	
}

macro "set options [f7]" {
	setOptions();
}

macro "Launch export (f8) Action Tool - CbbbD61C444L7181CcccD91CaaaD52C000D62C555L7282C000D92CaaaDa2CcccD43C000D53CaaaD63D93C000Da3CcccDb3C555D44C444D54CdddL7484C444Da4C555Db4C111D45C999D55CdddD65C000L7585CeeeD95C999Da5C111Db5C000D46CcccD56CdddD66C000L7686CeeeD96CcccDa6C000Db6D47CcccD57CeeeL7787CcccDa7C000Db7D48CcccD58Da8C000Db8D49CcccD59Da9C000Db9C666D3aC000D4aCeeeD5aDaaC000DbaC666DcaCdddD2bC000D3bC111D4bC444L5babC111DbbC000DcbCdddDdbD2cC444L3cccCdddDdcCeeeD5dC444D6dCaaaL7d8dC444D9dCeeeDadC777D6eC000L7e8eC777D9eCbbbL7f8f" {
	launchExport();
}

macro "launch export [f8]" {
	launchExport();
}

function launchExport() {
	print("3, 2, 1, go...");
	_OPERA_INDEX_FILE = getIndexFile();
	options = "--wells=";
	if (_EXPORT_ALL) options = options + "all";
	else {
		for (i = 0; i < _WELLS.length; i++) {
			if (!_SELECTED_WELLS[i]) continue;
			options = options + _WELLS[i];			
		}
	}
	options = options + " --slice=" + _ZSLICE;
	options = options + " --channel=" + _CHANNEL;
	if (_CREATE_Z_STACK) options = options + " --stack";
	if (_MERGE_CHANNELS) options = options + " --merge";
	if (_DO_MIP) options = options + " --mip";
	if (_NORMALIZE) options = options + " --normalize";
	options = options + " --fusion-method=" + _FUSION_METHOD; 
	options = options + " --regression-threshold=" + _REGRESSION_THRESHOLD;
	options = options + " --displacement-threshold=" + _DISPLACEMENT_THRESHOLD;
	options = options + " --abs-displacement-threshold=" + _ABS_DISPLACEMENT_THRESHOLD;
	options = options + " --pseudoflatfield=" + _PSEUDO_FLAT_FIELD_RADIUS;
	options = options + " --rollingball=" + _ROLLING_BALL_RADIUS;
	options = options + " --subtract-background-radius=" + _FIND_AND_SUB_BACK_RADIUS;
	options = options + " --subtract-background-offset=" + _FIND_AND_SUB_BACK_OFFSET;
	options = options + " --subtract-background-iterations=" + _FIND_AND_SUB_BACK_ITERATIONS;
	options = options + " --subtract-background-skip=" + _FIND_AND_SUB_BACK_SKIP;
	colors = String.join(_SELECTED_COLORS);
	colors = replace(colors, " ", "");
	options = options + " --colours=" + colors;
	options = options + " " + _OPERA_INDEX_FILE;
	macrosDir = getDirectory("macros");
	script = File.openAsString(macrosDir + "/toolsets/opera_export_tools.py");
	call("ij.plugin.Macro_Runner.runPython", script, options); 
	print("The eagle has landed!!!");
}

function setOptions() {
	Dialog.create("Options");
	Dialog.addNumber("z-slice for stitching (0 for middle slice)", _ZSLICE);
	Dialog.addNumber("channel for stitching", _CHANNEL);
	Dialog.addCheckbox("create z-stack", _CREATE_Z_STACK);
	Dialog.addCheckbox("merge channels", _MERGE_CHANNELS);
	Dialog.addCheckbox("apply z-projection", _DO_MIP);
	Dialog.addMessage("Image correction/normalization:");
	Dialog.addNumber("pseudo flat field radius (0 to switch off): ", _PSEUDO_FLAT_FIELD_RADIUS);
	Dialog.addNumber("rolling ball radius (0 to switch off): ", _ROLLING_BALL_RADIUS);
	Dialog.addCheckbox("normalize", _NORMALIZE);
	Dialog.addNumber("find background radius (0 to switch off): ", _FIND_AND_SUB_BACK_RADIUS);
	Dialog.addToSameRow();
	Dialog.addNumber("find background offset: ", _FIND_AND_SUB_BACK_OFFSET);
	Dialog.addNumber("find background iterations: ", _FIND_AND_SUB_BACK_ITERATIONS);
	Dialog.addToSameRow();
	Dialog.addNumber("find background skip limit: ", _FIND_AND_SUB_BACK_SKIP);
	Dialog.addMessage("Fusion parameters:");
	Dialog.addChoice("method: ", _FUSION_METHODS, _FUSION_METHOD);
	Dialog.addNumber("regression threshold: ", _REGRESSION_THRESHOLD);
	Dialog.addNumber("max/avg displacement threshold: ", _DISPLACEMENT_THRESHOLD);
	Dialog.addNumber("absolute displacement threshold: ", _ABS_DISPLACEMENT_THRESHOLD);
	Dialog.addMessage("Colours:");
	Dialog.addChoice("ch1: ", _COLORS, _SELECTED_COLORS[0]);
	Dialog.addToSameRow();
	Dialog.addChoice("ch2: ", _COLORS, _SELECTED_COLORS[1]);
	Dialog.addToSameRow();
	Dialog.addChoice("ch3: ", _COLORS, _SELECTED_COLORS[2]);
	Dialog.addChoice("ch4: ", _COLORS, _SELECTED_COLORS[3]);
	Dialog.addToSameRow();
	Dialog.addChoice("ch5: ", _COLORS, _SELECTED_COLORS[4]);
	Dialog.addToSameRow();
	Dialog.addChoice("ch6: ", _COLORS, _SELECTED_COLORS[5]);
	Dialog.addChoice("ch7: ", _COLORS, _SELECTED_COLORS[6]);
	
	Dialog.show();
	_ZSLICE = Dialog.getNumber();
	_CHANNEL = Dialog.getNumber();
	_CREATE_Z_STACK = Dialog.getCheckbox();
	_MERGE_CHANNELS = Dialog.getCheckbox();
	_DO_MIP = Dialog.getCheckbox();	

	_PSEUDO_FLAT_FIELD_RADIUS = Dialog.getNumber();
	_ROLLING_BALL_RADIUS = Dialog.getNumber();
	_NORMALIZE = Dialog.getCheckbox();
	_FIND_AND_SUB_BACK_RADIUS = Dialog.getNumber();
	_FIND_AND_SUB_BACK_OFFSET = Dialog.getNumber();
	_FIND_AND_SUB_BACK_ITERATIONS = Dialog.getNumber();
	_FIND_AND_SUB_BACK_SKIP = Dialog.getNumber();

	_FUSION_METHOD = Dialog.getChoice();
	_REGRESSION_THRESHOLD = Dialog.getNumber();
	_DISPLACEMENT_THRESHOLD = Dialog.getNumber();
	_ABS_DISPLACEMENT_THRESHOLD = Dialog.getNumber();

	_SELECTED_COLORS[0] = Dialog.getChoice();
	_SELECTED_COLORS[1] = Dialog.getChoice();
	_SELECTED_COLORS[2] = Dialog.getChoice();
	_SELECTED_COLORS[3] = Dialog.getChoice();
	_SELECTED_COLORS[4] = Dialog.getChoice();
	_SELECTED_COLORS[5] = Dialog.getChoice();
	_SELECTED_COLORS[6] = Dialog.getChoice();
}

function selectWells() {
	_OPERA_INDEX_FILE = getIndexFile();
	_WELLS = getWells();
	wells = _WELLS;
	if (_SELECTED_WELLS.length != _WELLS.length) _SELECTED_WELLS = newArray(_WELLS.length);
	Dialog.create("Select Wells");
	lastRow = "00";
	for (i = 0; i < wells.length; i++) {
		well = wells[i];
		row = substring(well, 0, 2);  
		if (row==lastRow) {
			Dialog.addToSameRow();
		}
		lastRow = row;
		Dialog.addCheckbox(well, _SELECTED_WELLS[i]);
	}
	Dialog.addCheckbox("export all", _EXPORT_ALL);
	Dialog.show();
	for (i = 0; i < wells.length; i++) {
		well = wells[i];
		_SELECTED_WELLS[i] = Dialog.getCheckbox();
	}
	_EXPORT_ALL = Dialog.getCheckbox();
}

function setIndexFile() {
	newFile  = File.openDialog("Please select the index file (Index.idx.xml)!");
	newFile = replace(newFile, "\\", "/");
	if (File.exists(newFile)) {
		setIndexFileDefault(newFile);
	}
}

function getIndexFile() {
	res = _OPERA_INDEX_FILE;
	if (!File.exists(res)) res = getIndexFileDefault();
	return res;
}

function getIndexFileDefault() {
	return call("ij.Prefs.get", "operaExportTools.indexFile", "");
}

function setIndexFileDefault(path) {
	call("ij.Prefs.set", "operaExportTools.indexFile", path); 
}

function getWells() {
	content = File.openAsRawString(_OPERA_INDEX_FILE, _BYTES_TO_READ);
	lines = split(content, "\n");
	wells = newArray(0);
	started = false;
	finished = false;
	for (i = 0; i < lines.length && !finished; i++) {
		line = String.trim(lines[i]);
		if (startsWith(line, "<Well id=")) {
			started = true;
			line = replace(line, '<Well id="', "");
			line = replace(line, '" />', "");
			wells = Array.concat(wells, line);
		} else {
			if (started) finished = true;
		}
	}
	return wells;
}

function getNrOfRowsAndColumns() {
	indexFile = getIndexFile();
	content = File.openAsRawString(indexFile, _BYTES_TO_READ);
	lines = split(content, "\n");
	found=false;
	nrCols = 0;
	nrRows = 0;
	for (i = 0; i < lines.length && !found; i++) {
		line = String.trim(lines[i]);
		if (startsWith(line, "<PlateRows>")) {
			line = replace(line, "<PlateRows>", "");
			line = replace(line, "</PlateRows>", "");
			nrRows = parseInt(line);
			line = String.trim(lines[i+1]);
			line = replace(line, "<PlateColumns>", "");
			line = replace(line, "</PlateColumns>", "");
			nrCols = parseInt(line);
			found = true;
		}
	}
	res = newArray(nrRows, nrCols);
	return res;
}
