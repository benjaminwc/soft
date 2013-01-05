﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.OleDb;
using System.Diagnostics;
using System.IO;
using Microsoft.Win32;

namespace MarkMars.Database
{
    public class AccessDatabase : IFileDatabase
    {
		private static AccessType m_AccessType = AccessType.None;
		private IFileDatabase m_IAccess = null;

        /// <summary>
        /// Access数据库类构造函数
        /// </summary>
        /// <param name="strMDBPath">mdb文件完整路径</param>
        /// <param name="strPassword">mdb文件密码</param>
        /// <param name="bReadOnly">是否只读</param>
        public AccessDatabase(string strMDBPath, string strPassword, bool bReadOnly = false)
        {
            if (m_AccessType == AccessType.None)//自动检测
			{
				StringBuilder sb = new StringBuilder();
				try
				{
                    m_IAccess = new AccessDatabase_OLEDB_JET(strMDBPath, strPassword, bReadOnly);
					m_AccessType = AccessType.OLEDB_JET;
				}
				catch (Exception e)
				{
					sb.AppendLine("JET:");
					sb.AppendLine(e.Message);
					sb.AppendLine(string.Empty);
				}

				if (m_IAccess == null)
				{
					try
					{
						m_IAccess = new AccessDatabase_OLEDB_ACE(strMDBPath, strPassword);
						m_AccessType = AccessType.OLEDB_ACE;
					}
					catch (Exception e)
					{
						sb.AppendLine("ACE:");
						sb.AppendLine(e.Message);
						sb.AppendLine(string.Empty);
					}
				}

				if (m_IAccess == null)
				{
					try
					{
						m_IAccess = new AccessDatabase_ODBC(strMDBPath, strPassword);
						m_AccessType = AccessType.ODBC;
					}
					catch (Exception e)
					{
						sb.AppendLine("ODBC:");
						sb.AppendLine(e.Message);
						sb.AppendLine(string.Empty);

						throw new Exception(sb.ToString());
					}
				}
			}
			else
			{
				switch (m_AccessType)
				{
					case AccessType.ODBC:
						m_IAccess = new AccessDatabase_ODBC(strMDBPath, strPassword);
						break;
					case AccessType.OLEDB_ACE:
						m_IAccess = new AccessDatabase_OLEDB_ACE(strMDBPath, strPassword);
						break;
					case AccessType.OLEDB_JET:
                        m_IAccess = new AccessDatabase_OLEDB_JET(strMDBPath, strPassword, bReadOnly);
						break;
					default:
						Debug.Assert(false);
						break;
				}
			}
        }

        /// <summary>
        /// mdb文件名
        /// </summary>
        public string FileName
        {
			get
			{
				return m_IAccess.FileName;
			}
        }

        /// <summary>
        /// 得到DataTable
        /// </summary>
        /// <param name="strSQL">sql语句</param>
        /// <returns>DataTable</returns>
        public DataTable GetTableBySQL(string strSQL)
        {
            try
            {
				return m_IAccess.GetTableBySQL(strSQL);
            }
            catch (Exception e)
            {
				System.Windows.Forms.MessageBox.Show("GetTableBySQL 错误:" + Environment.NewLine + strSQL + Environment.NewLine + this.FileName + Environment.NewLine + e.Message + Environment.NewLine + e.StackTrace);
				return null;
            }
        }

        /// <summary>
        /// 得到DataRow
        /// </summary>
        /// <param name="strSQL">sql语句</param>
        /// <returns>DataRow</returns>
        public DataRow GetRowBySQL(string strSQL)
        {
			return m_IAccess.GetRowBySQL(strSQL);
        }

        /// <summary>
        /// 执行sql语句
        /// </summary>
        /// <param name="strSQL">sql语句</param>
        public void ExecuteSQL(string strSQL)
        {
            try
            {
                m_IAccess.ExecuteSQL(strSQL);
            }
            catch (Exception e)
            {
                System.Windows.Forms.MessageBox.Show("ExecuteSQL 错误:" + Environment.NewLine + strSQL + Environment.NewLine + this.FileName + Environment.NewLine + e.Message + Environment.NewLine + e.StackTrace);
                return;
            }
        }

        /// <summary>
        /// 获得最大id
        /// </summary>
        /// <returns>最大id</returns>
		public int GetLastID()
		{
			return m_IAccess.GetLastID();
		}

        /// <summary>
        /// 关闭连接
        /// </summary>
        public void CloseConnection()
        {
			m_IAccess.CloseConnection();
        }

        /// <summary>
        /// 判断Access库中是否有相应的表
        /// </summary>
        /// <param name="strTableName">表名</param>
        /// <returns>是否存在</returns>
        public bool TableExists(string strTableName)
        {
			return m_IAccess.TableExists(strTableName);
        }

        /// <summary>
        /// 判断字段是否在表中存在
        /// </summary>
        /// <param name="strTableName">表名</param>
        /// <param name="strFieldName">字段名</param>
        /// <returns>是否存在</returns>
        public bool FieldExists(string strTableName, string strFieldName)
        {
			return m_IAccess.FieldExists(strTableName, strFieldName);
        }

        /// <summary>
        /// 打开连接
        /// </summary>
		public void OpenConnection()
		{
			m_IAccess.OpenConnection();
		}
    }
}
