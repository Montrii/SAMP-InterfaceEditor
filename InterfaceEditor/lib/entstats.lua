-- EntStats is a short library for SAMP
-- which allows to gain information about your character, other characters
-- or addtional information in specfic cases.
-- Own standing project.
-- Check <githublink here>.

local key = require "vkeys"
local moon = require "MoonAdditions"
local ffi =			require "ffi"
require"lib.sampfuncs"

assert(getMoonloaderVersion() >= 026, 'EntStats requires moonloader v.026 or greater.')

entstats.AlsoPrintInConsole = true
entstats.AlsoPrintInChat = false
entstats.AllowLogCommands = false
entstats.UseLogCreationButton = key.VK_W
entstats.UseLogDeletionButton = key.VK_S
entstats.ShowSuccessfulLog = false



------- .createAimingEntityInformation(string path, bool usePlayerNameAsConfig, bool storeInformation) | creates a Config File with good amount of the aimed Entity Information and also returns you every information (if storeInformation == true). Returns filename and Creationdate.---
------- .deleteAimingEntityInformation(string path, string filename, bool keepInformation) | deletes the Config File created by the opposite function, but allows you to keep the information (depends on situation if the information is outdated or not). Will return the Information as variables (Use as global to gain access outside of functions) and Creationdate.
------ .gainAimingEntityInformation(bool HealthInformation, bool ActingInformation) | Allows you gain information based around a timestamp in form of varabiesl. Depends on what information you decided to get.
------ .createDeathLogInformation(string path) | Creates a Deathlog when you die and showcases the information over your killer

function entstats.createAimingEntityInformation()
end

function entstats.deleteAimingEntityInformation()
end

return entstats
