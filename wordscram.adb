with ada.Text_IO; use Ada.Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with ada.characters.handling; use ada.characters.handling;
with ada.numerics.discrete_random;

procedure wordscram is
	fileName : unbounded_string;
	isSuccessful : integer;

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

	function randomInt(lowerBound: integer; upperBound: integer) return integer is
		-- Initialize random number generator package
		subtype random_range is Integer range lowerBound..upperBound;
		package rand_int is new ada.numerics.discrete_random(random_range);
		use rand_int;
		gen: rand_int.Generator;
		randomInt: random_range;
	begin
		rand_int.reset(gen);
		randomInt := Random(gen);
		return randomInt;
	end randomInt;

	function scrambleWord(word: unbounded_string; length: integer) return unbounded_string is
 		newWord: string(1..length);
 		finalWord: unbounded_string;
 		usedIndices: array(1..length) of integer;
 		randInt: integer;
	begin
		-- Initialize a way to keep track of all used indices
		usedIndices := (1..length => 0);

		-- Set first and last char of word to be the same
		newWord(1) := Element(word, 1);
		newWord(length) := Element(word, length);

		for i in 2..length - 1 loop
			-- Calculate random number to determine the index of the old word. If it's already been used recalculate it
			randInt := randomInt(2, length - 1);
			while usedIndices(randInt) = 1 loop
				randInt := randomInt(2, length - 1);
			end loop;

			-- Set new word with old word letter
			newWord(i) := Element(word, randInt);
			usedIndices(randInt) := 1;
		end loop;

		finalWord := to_unbounded_string(newWord);
		return finalWord;
	end scrambleWord;

	function isWord(word: unbounded_string) return boolean is
	begin
		-- Go through each letter in the word and determine if it's a letter
		for i in 1..length(word) loop
			if is_letter(Element(word, i)) = False then
				return False;
			end if;
		end loop;
		return True;
	end isWord;

	function processText(fileName : string) return integer is
		infp: file_type;
		line: unbounded_string;
		wordStart, wordLen: integer;
	begin
		open(infp, in_file, fileName);
		loop
			exit when end_of_file(infp);
			line := get_line(infp);

			wordLen := 0;
			wordStart := 1;

			-- Loop through line in the file, splitting the line by words
			-- This is done by keeping track of the word's start index and length
			for i in 1..length(line) loop
				if Element(line, i) = ' ' or Element(line, i) = '.' or Element(line, i) = ',' then
					if wordLen > 3 and isWord(unbounded_slice(line, wordStart, wordStart + wordLen - 1)) = True then
						put(scrambleWord(unbounded_slice(line, wordStart, wordStart + wordLen - 1), wordLen));
					else
						put(unbounded_slice(line, wordStart, wordStart + wordLen - 1));
					end if;
					wordStart := i + 1;
					wordLen := 0;
					put(Element(line, i));
				else 
					wordLen := wordLen + 1;
				end if;
			end loop;

			-- This is needed because if the line doesn't end with a delimiter, it will skip that word.
			if wordLen > 0 then
				if wordLen > 3 and isWord(unbounded_slice(line, wordStart, wordStart + wordLen - 1)) = True then
					put(scrambleWord(unbounded_slice(line, wordStart, wordStart + wordLen - 1), wordLen));
				else
					put(unbounded_slice(line, wordStart, wordStart + wordLen - 1));
				end if;
			end if;
			put_line("");
		end loop;

		return 1;
	end processText;


begin
	filename := getFilename;
	isSuccessful := processText(to_string(filename));
	if isSuccessful = 1 then
		put_line("Successfully finished processing text");
	end if;
end wordscram;
