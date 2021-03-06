﻿using System;
using System.Collections.Generic;
$if$ ($targetframeworkversion$ >= 3.5)using System.Linq;
$endif$$if$ ($targetframeworkversion$ >= 4.5)using System.Threading.Tasks;
$endif$using System.Windows.Forms;

namespace $safeprojectname$
{
    /// <summary>  
    /// 作者：MarkMars  
    /// 时间：$time$  
    /// 版权：Copyright (C) $year$ MarkMars All Rights Reserved  
    /// CLR版本：$clrversion$  
    /// 博客地址：http://www.wakealone.com  
    /// $safeitemrootname$说明：本代码版权归MarkMars所有，使用时必须带上MarkMars博客地址  
    /// </summary>  
    static class Program
    {
        /// <summary>
        /// 应用程序的主入口点。
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1());
        }
    }
}
