-- File: wordscram.adb
-- Name: Peter Hudel
-- Student Number: 1012673
-- Date: 02/28/2020
-- Description: This program takes in a filename with plain text in it, then scrambles up any 
--              words that are greater than 3 letters long.

-- with and use statements
with ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;
with ada.characters.handling; use ada.characters.handling;
with ada.numerics.discrete_random;

procedure wordscram is
	fileName : unbounded_string;
	numberOfProcessed : integer;

	-- Helper function for getFilename: determines if a file exists or not
	-- Param: fileName: The filename to check if it exists
	-- Return: Boolean True if it does exist
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
	-- Return: String of the filename
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


	-- Helper function to calculate a random integer between certain bounds. Uses numerics discrete random to generate the number
	-- Param: lowerBound: an int representing the smallest number the random number can be
	-- Param: upperBound: an int representing the highest number the random number can be
	-- Return: the randomly generated number
	function randomInt(lowerBound: integer; upperBound: integer) return integer is
		-- Initialize random number generator package using the upper and lower bounds
		subtype random_range is Integer range lowerBound..upperBound;
		package rand_int is new ada.numerics.discrete_random(random_range);
		use rand_int;
		gen: rand_int.Generator;
		randomInt: random_range;

	begin
		-- Reset the generator then create the value
		rand_int.reset(gen);
		randomInt := Random(gen);
		return randomInt;

	end randomInt;

	-- Function that scrambles a word by generating random numbers
	-- Param: word: the word to be scrambled
	-- Param: length: The length of the word
	-- Return: The new, scrambled word as an unbounded string
	function scrambleWord(word: unbounded_string; length: integer) return unbounded_string is
 		newWord: string(1..length);
 		finalWord: unbounded_string;
 		usedIndices: array(1..length) of integer;
 		randInt: integer;

	begin
		usedIndices := (1..length => 0);
		-- Set first and last char of word to be the same
		newWord(1) := Element(word, 1);
		newWord(length) := Element(word, length);

		for i in 2..length - 1 loop
			randInt := randomInt(2, length - 1);
			while usedIndices(randInt) = 1 loop
				randInt := randomInt(2, length - 1);
			end loop;

			-- Set new word with old word letter and keep track of the position
			newWord(i) := Element(word, randInt);
			usedIndices(randInt) := 1;
		end loop;

		finalWord := to_unbounded_string(newWord);
		return finalWord;

	end scrambleWord;

	-- Helper function that determines if something is a word. Note that words 
	-- with punctuation in them, such as ' will be treated as not a word since it's not an alpha character
	-- Param: word: the string to determine if it is a word
	-- Return: boolean: true if it is a word, false otherwise
	function isWord(word: unbounded_string) return boolean is

	begin
		for i in 1..length(word) loop
			if is_letter(Element(word, i)) = False then
				return False;
			end if;
		end loop;
		return True;

	end isWord;

	-- Driver function that processes a file and scrambles all the words in it
	-- Param: fileName: the filename that is loaded in for words to be scrambled
	-- Return: int stating how many words were successfully scrambled
	function processText(fileName : string) return integer is
		infp: file_type;
		line: unbounded_string;
		wordStart, wordLen, numProcessed: integer;

	begin
		open(infp, in_file, fileName);
		numProcessed := 0;
		loop
			exit when end_of_file(infp);
			line := get_line(infp);

			wordLen := 0;
			wordStart := 1;

			-- Loop through line in the file, splitting the line by words
			-- This is done by keeping track of the word's start index and length
			for i in 1..length(line) loop
				-- When we meet certain delimiters, or if we reach the end of the line we know the end of a word was reached
				if i = length(line) or Element(line, i) = ' ' or Element(line, i) = '.' or Element(line, i) = ',' or Element(line, i) = '?' or Element(line, i) = '!' then
					if wordLen > 3 and isWord(unbounded_slice(line, wordStart, wordStart + wordLen - 1)) = True then
						numProcessed := numProcessed + 1;
						put(scrambleWord(unbounded_slice(line, wordStart, wordStart + wordLen - 1), wordLen));
					else
						put(unbounded_slice(line, wordStart, wordStart + wordLen - 1));
					end if;

					-- Reset word indices and print out the current character
					wordStart := i + 1;
					wordLen := 0;
					put(Element(line, i));
				else 
					wordLen := wordLen + 1;
				end if;

			end loop;

			put_line("");
		end loop;

		return numProcessed;

	end processText;


-- Main loop of the program
begin
	filename := getFilename;
	numberOfProcessed := processText(to_string(filename));
	put("Number of scrambled words: ");
	put(numberOfProcessed);

end wordscram;
