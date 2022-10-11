//# The list below replaces the use of 'move_rope'
::InitializeConstants<-function()
{
    if(!::state.exists("CONST_TIME"))
    {
        ::state.CONST_TIME <- 0;
    }
    if(!::state.exists("CONST_HEADSHOTS"))
    {
        ::state.CONST_HEADSHOTS <- 0;
    }
    if(!::state.exists("CONST_HP"))
    {
        ::state.CONST_HP <- 0;
    }
    if(!::state.exists("CONST_SCORE"))
    {
        ::state.CONST_SCORE <- 0;
    }
    if(!::state.exists("FIRST_START"))
    {
        ::state.FIRST_START <- 1;
    }
    if(!::state.exists("SOUND"))
    {
        ::state.SOUND <- 1;
    }
    if(!::state.exists("CONST_SHOTS"))
    {
        ::state.CONST_SHOTS <- 0;
    }
    if(!::state.exists("CONST_DIFF_RESET"))
    {
        ::state.CONST_DIFF_RESET <- 0;
    }
    if(!::state.exists("BOMB_PLANT"))
    {
        ::state.BOMB_PLANT <- 0;
    }
    if(!::state.exists("CONST_DIFF"))
    {
        ::state.CONST_DIFF <- 2;
    }
    if(!::state.exists("CONST_KTIME"))
    {
        ::state.CONST_KTIME <- 0;
    }
}
EntFire("@script", "runscriptcode", "InitializeConstants()",  0.1, null);