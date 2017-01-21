--[[

This file is created for AutoPlay Media Studio 8.x and will not work in native Lua unless you convert the AMS native functions
to lua, most functions should be in Lua so should be able to be converted.


Created By Rexzooly Kai Black, Idea from 2006 created on 9th Jan 2017
]]--

NoKey = {
  MinVersion = "",
  Version = "",
  -- part of the mix up and ecoding, add more, the demo I how off has over 20
  -- www.youtube.com/watch?v=xK1E3NxiNlQ
	Mix = {
		{"WordBefore", "WordAfter"},		
	},
  -- More Mixing up and encoding
	Replace = {
		{"A", "{01000001}"},{"a", "[01100001]"},
		{"B", "{01000010}"},{"b", "[01100010]"},
		{"C", "{01000011}"},{"c", "[01100011]"},
		{"D", "{01000100}"},{"d", "[01000100]"},
		{"E", "{01000101}"},{"e", "[01100101]"},
		{"F", "{01000110}"},{"f", "[01100110]"},
		{"G", "{01000111}"},{"g", "[01100111]"},
		{"H", "{01001000}"},{"h", "[01101000]"},
		{"I", "{01001001}"},{"i", "[01101001]"},
		{"J", "{01001010}"},{"j", "[01101010]"},		
		--{"K", "{01001011}"},{"k", "[01101011]"},
		--{"L", "{01001100}"},{"l", "[01101100]"},
		--{"M", "{01001101}"},{"m", "[01101101]"},		
		--{"N", "{01001110}"},{"n", "[01101110]"},		
		{"O", "{01001111}"},{"o", "[01101111]"},		
		--{"P", "{01010000}"},{"p", "[01110000]"},		
		--{"Q", "{01010001}"},{"q", "[01110001]"},		
		--{"R", "{01010010}"},{"r", "[01110010]"},
		{"S", "{01010011}"},{"s", "[01110011]"},
		--{"T", "{01010100}"},{"t", "[01110100]"},
		--{"U", "{01010101}"},{"u", "[01110101]"},
		--{"V", "{01010110}"},{"v", "[01110110]"},
		--{"W", "{01010111}"},{"w", "[01110111]"},
		--{"X", "{01011000}"},{"x", "[01011000]"},
		--{"Y", "{01011001}"},{"y", "[01111001]"},
		--{"Z", "{01011010}"},{"z", "[01111010]"},
		{" ", "{00100000}"},{".", "{00101110}"},
		{",", "{00101100}"},{"'", "{00100111}"},
		{"\\", "{00000}"},{"/", "{00101111}"},
		{"#", "{00100011}"}, {"@", "{01000000}"},
		{"-", "{00101101}"},{"=", "{00111101}"},
		{"!", "{00100001}"},{"?", "{00111111}"},
		{"\"", "{00100010}"},{"£", "{11000010 10100011}"},
		{"$", "{00100100}"},{"%", "{00100101}"},
		{"*", "{00101010}"}
	}
}

-- hide a word in the app becore packing
function NoKey.Bow(_strString, _bBlock)
	if type(_strString) == nil then
		return false, 'Nothing given'
	end	
	if _bBlock then
		bowthis = string.gsub(_strString, "enc::(.-)::", function(a) return "<span class=\"block\" style=\"display:none;\">"..Crypto.Rot13(enc(a)).."</span>" end);
	else
		bowthis = string.gsub(_strString, "enc::(.-)::", function(a) return "dec::"..Crypto.Rot13(enc(a)).."::" end);
	end
	NewString = bowthis; 
	return NewString;
end

-- unhide a word
function NoKey.DeBow(_strString, _bBlock)
	if type(_strString) == nil then
		return false, 'Nothing given'
	end
	if _bBlock then
		bowthis = string.gsub(_strString, "<span class=\"block\" style=\"display:none;\">(.-)</span>", function(a) return "enc::"..dec(Crypto.Rot13(a)).."::" end);
	else
		bowthis = string.gsub(_strString, "dec::(.-)::", function(a) return "enc::"..dec(Crypto.Rot13(a)).."::" end);	
	end
	NewString = bowthis;
	return NewString;
end

--First part of the encoding
function NoKey.AlphaChannel(_strString)
	if type(_strString) == nil then
		return false, 'Nothing given'
	end
	if type(NoKey.Mix) == nil then
		return false, 'No replacements found'
	end
	for x = 1, Table.Count(NoKey.Mix) do
		_strString = String.Replace(_strString, NoKey.Mix[x][1], enc(NoKey.Mix[x][2]), true);
	end
	for x = 1, Table.Count(NoKey.Replace) do
		_strString = String.Replace(_strString, NoKey.Replace[x][1], NoKey.Replace[x][2], true);
	end
	for x = 1, Table.Count(NoKey.Replace) do
		_strString = String.Replace(_strString, NoKey.Replace[x][2], enc(NoKey.Replace[x][2]), true);
	end
	return string.reverse(enc(string.reverse(_strString)))
end

--Last part of the decoding
function NoKey.BetaChannel(_strString)
    _strString = string.reverse(dec(string.reverse(_strString)))
	if type(_strString) == nil then
		return false, 'Nothing given'
	end
	if type(NoKey.Mix) == nil then
		return false, 'No replacements found'
	end
	for x = 1, Table.Count(NoKey.Replace) do
		_strString = String.Replace(_strString, enc(NoKey.Replace[x][2]), NoKey.Replace[x][2], true);
	end
	for x = 1, Table.Count(NoKey.Replace) do
		_strString = String.Replace(_strString, NoKey.Replace[x][2], NoKey.Replace[x][1], true);
	end
	for x = 1, Table.Count(NoKey.Mix) do
		_strString = String.Replace(_strString, enc(NoKey.Mix[x][2]), NoKey.Mix[x][1], true);
	end
	return _strString
end

function NoKey.Lock(Dep, strKey)
	if strKey == "" then
		strKey = nil;
	end
	if Dep ~= "" and Dep ~= nil then
		The_Next = Dep;
		if strKey == nil then
			The_Auth = enc("01001110011011110100110101101111011100100110010101001011011001010111100101100010011011110110000101110010011001000101000001100101011011110111000001101100011001010011001000110000001100010011011101000101011100000110100101100011010100000110100101100101");
			SkyLandOverRide = 'SNBLOCK';
		else
			The_Auth = strKey;
			SkyLandOverRide = 'PNBLOCK';
		end
		TextFile.WriteFromString(_TempFolder.."\\open.blob", The_Next, false);
   
   -- Start CHANGE THIS TO YOUR AESCRYPT EXE ("Tools\\handle.exe" to PATH-TO-YOUR-AESCrypt-EXE)
		Running = File.Run("Tools\\handle.exe", "-e -p "..The_Auth.." open.blob", _TempFolder.."\\", SW_HIDE, true);
	 --	End CHANGE
    File.Delete(_TempFolder.."\\open.blob", true, true, true);
		The_Start = Crypto.Base64EncodeToString(_TempFolder.."\\open.blob.aes", 70);
		Save_Me = SkyLandOverRide..The_Start;
		File.Delete(_TempFolder.."\\open.blob.aes", true, true, true);
		return enc(Save_Me);
	else
		return 'error';
	end
end
function NoKey.UnLock(Dep, strKey)
	if strKey == nil then
    -- NoMoreKeyboardPeople2017EpicPie
		The_Auth = enc("01001110011011110100110101101111011100100110010101001011011001010111100101100010011011110110000101110010011001000101000001100101011011110111000001101100011001010011001000110000001100010011011101000101011100000110100101100011010100000110100101100101");
		SkyLandOverRide = 'SNBLOCK';
	else
		The_Auth = enc(Crypto.Rot13(strKey));
		SkyLandOverRide = 'PNBLOCK';
	end
	if Dep ~= "" and Dep ~= nil then
		Dep = dec(Dep);
	else
		return 'error';
	end
	Dep = String.Replace(Dep, SkyLandOverRide, "", true);
	Crypto.Base64DecodeFromString(Dep, _TempFolder.."\\open.blade.aes");
	if not File.DoesExist(_TempFolder.."\\open.blade.aes") then
		--
	end
  
  -- Start CHANGE THIS TO YOUR AESCRYPT EXE ("Tools\\handle.exe" to PATH-TO-YOUR-AESCrypt-EXE)
	Running = File.Run("Tools\\handle.exe", "-d -p "..The_Auth.." open.blade.aes", _TempFolder.."\\", SW_HIDE, true);
	 --	End CHANGE
   
  Application.Sleep(600);  -- Not really needed, I used it to help UI and AMS to stay inline with each other two fast makes you think its broken
	if not File.DoesExist(_TempFolder.."\\open.blade") then
		--
	end
	The_Again = TextFile.ReadToString(_TempFolder.."\\open.blade");
	File.Delete(_TempFolder.."\\open.blade", true, true, true);
	File.Delete(_TempFolder.."\\open.blade.aes", true, true, true);
	return The_Again;
end
function NoKey.Pack(m_key, __SaveText, SaveMe, __Format)
	if m_key == "" then
		IDPASS = Dialog.Message("No key provided", "You have not set the key/password, do you want to use the software key?\r\n\r\nYes - Use Software Key (Not Recommended).\r\nNo - Set own key.\r\nCancel - Stop action.", MB_YESNOCANCEL, MB_ICONNONE, MB_DEFBUTTON1);
		if IDPASS == IDYES then
			__SaveText = NoKey.Lock(NoKey.AlphaChannel(NoKey.Bow(__SaveText)));
		end		
		if IDPASS == IDNO then
			UserKey = Dialog.PasswordInput("Key Input", "Enter your key below", MB_ICONNONE);			
			if UserKey ~= "CANCEL" then
				if UserKey ~= "" then 
					__SaveText = NoKey.Lock(NoKey.AlphaChannel(NoKey.Bow(__SaveText)), UserKey);
					return true
				else
					return false, "We was unable to tape up your package, reason below:\r\n\r\nThe user(you) has canceled the action";
				end	
			end
		end		
		if IDPASS == IDCANCEL then
			return false, "We was unable to tape up your package, reason below:\r\n\r\nThe user(you) has canceled the action";
		end	
	else
		__SaveText = NoKey.Lock(NoKey.AlphaChannel(NoKey.Bow(__SaveText)), m_key);
	end	
	Application.Sleep(300);
	if __SaveText ~= "" then
		enksave = {
			"ENK "..NoKey.Version,
			enc(System.GetDate(DATE_FMT_EUROPE).."-"..System.GetTime(TIME_FMT_MIL)),
			__SaveText
		}
		Math.RandomSeed(Math.Random(1, 4000));
		RanNox = Math.Random(482, 882);
		TextFile.WriteFromTable(SaveMe, enksave, false);
	    error = Application.GetLastError();
	    if (error ~= 0) then
	        return false, _tblErrorMessages[error];
	    end
		return true, "";
	else
		return false, "We lost the curtains for packing";
	end
end
function NoKey.Unpack(m_key, __SaveText)
	if m_key == "" then
		IDPASS = Dialog.Message("No key provided", "You have not set the key/password, do you want to try the software key?\r\n\r\nYes - Use Software Key.\r\nNo - Use your own key.\r\nCancel - Stop action.", MB_YESNOCANCEL, MB_ICONNONE, MB_DEFBUTTON1);
		if IDPASS == IDYES then
			__SaveText = NoKey.DeBow(NoKey.BetaChannel(NoKey.UnLock(__SaveText)));
			__DoAction = true;
			return true, __SaveText;
		end
		if IDPASS == IDNO then
			UserKey = Dialog.PasswordInput("Key Input", "Enter your key below", MB_ICONNONE);
			if UserKey ~= "CANCEL" then
				if UserKey ~= "" then
					__SaveText = NoKey.DeBow(NoKey.BetaChannel(NoKey.UnLock(__SaveText, UserKey)));
					__DoAction = true;
					return true, "";
				else
					return false, "We was unable to tape up your package, reason below:\r\n\r\nThe user(you) has canceled the action";
				end
			end
		end
		if IDPASS == IDCANCEL then
			return false, "We was unable to tape up your package, reason below:\r\n\r\nThe user(you) has canceled the action";
		end	
	end
	__SaveText = NoKey.DeBow(NoKey.BetaChannel(NoKey.UnLock(__SaveText, m_key)));
	__DoAction = true;
	return true, "";
end

-- Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
-- licensed under the terms of the LGPL2

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
function enc(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end
function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end
