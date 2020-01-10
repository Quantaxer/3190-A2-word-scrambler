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
		i : integer;
		wordStart, wordLen: integer;
	begin
		open(infp, in_file, fileName);
		loop
			exit when end_of_file(infp);
			line := get_line(infp);

			wordLen := 0;
			wordStart := 1;
			i := 1;

			-- Loop through line in the file, splitting the line by words
			-- This is done by keeping track of the word's start index and length
			for i in 1..length(line) loop
				if Element(line, i) = ' ' or Element(line, i) = '.' or Element(line, i) = ',' then
					if wordLen > 0 then
						put_line(unbounded_slice(line, wordStart, wordStart + wordLen - 1));
					end if;
					wordStart := i + 1;
					wordLen := 0;
				else 
					wordLen := wordLen + 1;
				end if;
			end loop;

			-- This is needed because if the line doesn't end with a delimiter, it will skip that word.
			if wordLen > 0 then
				put_line(unbounded_slice(line, wordStart, wordStart + wordLen - 1));
			end if;

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
