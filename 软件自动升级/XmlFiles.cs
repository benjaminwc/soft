using System;
using System.IO;
using System.Windows.Forms;
using System.Xml;

namespace AutoUpdate
{
    /// <summary>
    /// XmlFiles ��ժҪ˵����
    /// </summary>
    public class XmlFiles : XmlDocument
    {
        public string XmlFileName { get; set; }

        public XmlFiles(string xmlFile)
        {
            XmlFileName = xmlFile;
            try
            {
                this.Load(xmlFile);
            }
            catch (Exception e)
            {
                MessageBox.Show("���������ļ�ʧ��!" + e.Message, "��ʾ", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }
        }
        /// <summary>
        /// ����һ���ڵ��xPath���ʽ������һ���ڵ�
        /// </summary>
        /// <param name="node"></param>
        /// <returns></returns>
        public XmlNode FindNode(string xPath)
        {
            XmlNode xmlNode = this.SelectSingleNode(xPath);
            return xmlNode;
        }
        /// <summary>
        /// ����һ���ڵ��xPath���ʽ������ֵ
        /// </summary>
        /// <param name="xPath"></param>
        /// <returns></returns>
        public string GetNodeValue(string xPath)
        {
            XmlNode xmlNode = this.SelectSingleNode(xPath);
            return xmlNode.InnerText;
        }
        /// <summary>
        /// ����һ���ڵ�ı��ʽ���ش˽ڵ��µĺ��ӽڵ��б�
        /// </summary>
        /// <param name="xPath"></param>
        /// <returns></returns>
        public XmlNodeList GetNodeList(string xPath)
        {
            XmlNodeList nodeList = this.SelectSingleNode(xPath).ChildNodes;
            return nodeList;
        }
    }
}
