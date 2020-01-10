with ada.Text_IO; use Ada.Text_IO;
with ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;

procedure wordscram is
	fileName : unbounded_string;
	temp: integer;

	-- Helper function for getFilename: determines if a file exists or not
	-- Param: fileName: The filename to check if it exists
	-- Return: Boolean
	function isFileExists(fileName : unbounded_string) return boolean is
		infp: file_type;

	begin
		open(infp, in_file, to_string(fileName));
		close(infp);
		return True;
	exception
		when name_error =>
			return False;
	end isFileExists;


	-- Function which gets user input for a filename then returns it to the main program. Re-prompts the user if it doesn't exist
	-- Return: String 
	function getFilename return unbounded_string is
	    filename: unbounded_string;

	begin
		put("Enter filename: ");
		get_line(filename);

		while isFileExists(filename) = False loop
			put("File does not exist, re-renter filename: ");
			get_line(filename);
		end loop;

		return filename;

	end getFilename;

	function processText(fileName : string) return integer is
		infp: file_type;
		line: unbounded_string;
	begin
		open(infp, in_file, fileName);
		loop
			exit when end_of_file(infp);
			line := get_line(infp);
			put(line);
		end loop;

		return 1;
	end processText;

	--function scrambleWord()


	--function isWord()


	function randomInt(lowerBound: integer; upperBound: integer) return integer is
		randomInt: integer;
	begin
		randomInt := 1;
		return randomInt;
	end randomInt;


begin
	filename := getFilename;
	temp := processText(to_string(filename));
	put(filename);
	put(length(filename));
	put(temp);
end wordscram;
