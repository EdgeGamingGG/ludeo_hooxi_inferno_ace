
////////////////////////////////////////////////
// Utility static class                       //
////////////////////////////////////////////////
class ::Utils
{
    static DEG2RAD = 0.01745329;  // 0.01745329251994329576
    static RAD2DEG = 57.29577951;
}

// Static function to get an angle between two locations on the Y axis
function Utils::GetAngleBetweenTwoLocations(vecFrom, vecTo)
{
    local diff = vecFrom - vecTo;
    local pitch = Utils.RAD2DEG * atan2(diff.z, diff.Length2D());
    local yaw = Utils.RAD2DEG * (atan2(diff.y, diff.x) + PI);

    return Vector(pitch, yaw, diff.z);
}

function Utils::GetTimeValues(time)
{
    local timeInteger = time.tointeger()
    // local millisecondsNumber = time % 1
    // local miliString = format("%.2f", millisecondsNumber)
    // local miliSplit = split(miliString, ".")
    // local milliseconds = miliSplit[1].tointeger()
    local seconds = timeInteger % 60
    local minutes = timeInteger / 60
    // local result = format("%02u:%02u.%02u", minutes, seconds, milliseconds)
	local result = format("%02u:%02u", minutes, seconds)
    return result
}

/*
* Math function to round a number to a specified number of decimals
*/
function Utils::Round(val, decimalPoints)
 {
	local f = pow(10, decimalPoints) * 1.0;
	local newVal = val * f;
	newVal = floor(newVal + 0.5)
	newVal = (newVal * 1.0) / f;
	return newVal;
}

/*
* Function to debug a variable to know which keys and values it has
*/
function Utils::PrintObject(obj) 
{
	foreach (key, value in obj) {
		printl("Key: " + key + " has the value: " + value);
	}
}

//Constrain a number to a given range
function Utils::Clamp(v,min,max)
{
	return v < min ? min : v > max ? max : v;
}

//Return the biggest of two numbers.
function Utils::Max(v1,v2)
{
	return v1 > v2 ? v1 : v2;
}

//Return the smallest of two numbers.
function Utils::Min(v1,v2)
{
	return v1 < v2 ? v1 : v2;
}
//Vector multiplication fix
function Utils::Mul(v1,v2)
{
	local typ = typeof(v2);
	if(typ == "integer" || typ == "float")
	{
		return Vector(v1.x*v2,v1.y*v2,v1.z*v2);
	}
	if(typ == "Vector")
	{
		return Vector(v1.x*v2.x,v1.y*v2.y,v1.z*v2.z);
	}
	return null;
}
function Utils::Abs(number)
{
	return number < 0 ? number*-1 : number;
}

function Utils::SortByTargetname(a,b)
{
    if(a.GetName()>b.GetName()) return 1;
    else if(a.GetName()<b.GetName()) return -1;
    return 0;
}