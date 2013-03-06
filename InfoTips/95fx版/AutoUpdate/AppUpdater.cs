using System;
using System.Web;
using System.IO;
using System.Net;
using System.Xml;
using System.Collections;
using System.Windows.Forms;
using System.ComponentModel;

namespace AutoUpdate
{
    /// <summary>
    /// updater ��ժҪ˵����
    /// </summary>
    public class AppUpdater : IDisposable
    {
        public string UpdaterUrl { get; set; }

        [System.Runtime.InteropServices.DllImport("Kernel32")]
        private extern static Boolean CloseHandle(IntPtr handle);
        private Component component = new Component();
        private bool disposed = false;
        private IntPtr handle;

        public AppUpdater() { }

        /// <summary>
        /// �����Ҫ���µ��ļ�
        /// </summary>
        /// <param name="serverXmlFile">��ʱ�����ļ�</param>
        /// <param name="localXmlFile">���������ļ�</param>
        /// <param name="updateFileList">��Ҫ���µ��ļ��б�</param>
        /// <returns>��Ҫ���µ��ļ�����</returns>
        public int CheckForUpdate(string serverXmlFile, string localXmlFile, out Hashtable updateFileList)
        {
            updateFileList = new Hashtable();
            if (!File.Exists(localXmlFile) || !File.Exists(serverXmlFile))
            {
                return -1;
            }

            XmlFiles serverXmlFiles = new XmlFiles(serverXmlFile);
            XmlFiles localXmlFiles = new XmlFiles(localXmlFile);

            XmlNodeList newNodeList = serverXmlFiles.GetNodeList("AutoUpdater/Files");
            XmlNodeList oldNodeList = localXmlFiles.GetNodeList("AutoUpdater/Files");

            int k = 0;
            for (int i = 0; i < newNodeList.Count; i++)
            {
                string[] fileList = new string[3];

                string newFileName = newNodeList.Item(i).Attributes["Name"].Value.Trim();
                string newVer = newNodeList.Item(i).Attributes["Ver"].Value.Trim();

                ArrayList oldFileAl = new ArrayList();
                for (int j = 0; j < oldNodeList.Count; j++)
                {
                    string oldFileName = oldNodeList.Item(j).Attributes["Name"].Value.Trim();
                    string oldVer = oldNodeList.Item(j).Attributes["Ver"].Value.Trim();

                    oldFileAl.Add(oldFileName);
                    oldFileAl.Add(oldVer);

                }
                int pos = oldFileAl.IndexOf(newFileName);
                if (pos == -1)
                {
                    fileList[0] = newFileName;
                    fileList[1] = newVer;
                    updateFileList.Add(k, fileList);
                    k++;
                }
                else if (pos > -1 && newVer.CompareTo(oldFileAl[pos + 1].ToString()) > 0)
                {
                    fileList[0] = newFileName;
                    fileList[1] = newVer;
                    updateFileList.Add(k, fileList);
                    k++;
                }
            }
            return k;
        }

        /// <summary>
        /// �������ص���ʱĿ¼
        /// </summary>
        /// <param name="downpath">��ʱĿ¼</param>
        public void DownAutoUpdateFile(string downpath)
        {
            if (!System.IO.Directory.Exists(downpath))
                System.IO.Directory.CreateDirectory(downpath);

            string serverXmlFile = downpath + @"/UpdateList.xml";
            try
            {
                WebRequest req = WebRequest.Create(this.UpdaterUrl);
                req.Proxy = null;
                WebResponse res = req.GetResponse();

                if (res.ContentLength <= 0)
                    return;
                if (res != null)
                    res.Close();
                if (req != null)
                    req.Abort();

                WebClient wClient = new WebClient();
                wClient.DownloadFile(this.UpdaterUrl, serverXmlFile);
            }
            catch (Exception e)
            {
                MessageBox.Show("�����ļ����ִ���!" + e.Message, "��ʾ", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }
        }
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        private void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    component.Dispose();
                }
                CloseHandle(handle);
                handle = IntPtr.Zero;
            }
            disposed = true;
        }
        ~AppUpdater()
        {
            Dispose(false);
        }
    }
}
