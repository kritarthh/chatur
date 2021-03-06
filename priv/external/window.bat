// 2>nul||@goto :batch
/*
:batch
@echo off
setlocal

::delete line when ready
del %~n0.exe >nul 2>nul


:: find csc.exe
set "csc="
for /r "%SystemRoot%\Microsoft.NET\Framework\" %%# in ("*csc.exe") do  set "csc=%%#"

if not exist "%csc%" (
   echo no .net framework installed
   exit /b 10
)

if not exist "%~n0.exe" (
   call %csc% /nologo /warn:0 /out:"%~n0.exe" "%~dpsfnx0" || (
      exit /b %errorlevel% 
   )
)
%~n0.exe %*
endlocal & exit /b %errorlevel%

*/


using System.Runtime.InteropServices;
using System;
using System.Text;
using System.Diagnostics;

/// <summary>
/// EnumDesktopWindows Demo - shows the caption of all desktop windows.
/// Authors: Svetlin Nakov, Martin Kulov 
/// Bulgarian Association of Software Developers - http://www.devbg.org/en/
/// </summary>
public class user32
{
    /// <summary>
    /// filter function
    /// </summary>
    /// <param name="hWnd"></param>
    /// <param name="lParam"></param>
    /// <returns></returns>
    public delegate bool EnumDelegate(IntPtr hWnd, int lParam);


    [DllImport("user32.dll", SetLastError=true)]
    static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
    /// <summary>
    /// check if windows visible
    /// </summary>
    /// <param name="hWnd"></param>
    /// <returns></returns>
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    /// <summary>
    /// return windows text
    /// </summary>
    /// <param name="hWnd"></param>
    /// <param name="lpWindowText"></param>
    /// <param name="nMaxCount"></param>
    /// <returns></returns>
    [DllImport("user32.dll", EntryPoint = "GetWindowText",
    ExactSpelling = false, CharSet = CharSet.Auto, SetLastError = true)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpWindowText, int nMaxCount);

    /// <summary>
    /// enumarator on all desktop windows
    /// </summary>
    /// <param name="hDesktop"></param>
    /// <param name="lpEnumCallbackFunction"></param>
    /// <param name="lParam"></param>
    /// <returns></returns>
    [DllImport("user32.dll", EntryPoint = "EnumDesktopWindows",
    ExactSpelling = false, CharSet = CharSet.Auto, SetLastError = true)]
    public static extern bool EnumDesktopWindows(IntPtr hDesktop, EnumDelegate lpEnumCallbackFunction, IntPtr lParam);
    
    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    static extern IntPtr GetForegroundWindow();

    /// <summary>
    /// entry point of the program
    /// </summary>
    static void Main()
    {
        var hWnd = GetForegroundWindow();
        StringBuilder strbTitle = new StringBuilder(1024);
        int nLength = user32.GetWindowText(hWnd, strbTitle, strbTitle.Capacity + 1);
        string strTitle = strbTitle.ToString();

        if (user32.IsWindowVisible(hWnd) && string.IsNullOrEmpty(strTitle) == false)
        {
            uint res;
            GetWindowThreadProcessId(hWnd,out res);
            Console.WriteLine(Process.GetProcessById((int)res).ProcessName+"::"+strTitle);
        }
    }
}
