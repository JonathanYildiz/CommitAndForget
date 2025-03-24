using System.IO;
using System.Text;

namespace CommitAndForget.Converter
{
  public static class ImageToHexConverter
  {
    /// <summary>
    /// Lokales Bild in Hexadezimal-String umwandeln um es in DB-Skripte einfügen zu können
    /// schreibweise: ...VALUES(X'...')
    /// </summary>
    /// <param name="imagePath"></param>
    /// <returns></returns>
    public static string ConvertImageToHex(string imagePath)
    {
      // 1. Bild als Byte-Array laden
      byte[] imageBytes = File.ReadAllBytes(imagePath);

      // 2. Byte-Array in einen Hexadezimal-String umwandeln
      StringBuilder hexString = new StringBuilder(imageBytes.Length * 2);
      foreach (byte b in imageBytes)
      {
        hexString.AppendFormat("{0:X2}", b);
      }

      // 3. Den Hexadezimal-String zurückgeben
      return hexString.ToString();
    }
  }
}
