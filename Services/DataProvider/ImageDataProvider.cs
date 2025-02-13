using System.Collections.ObjectModel;
using System.Data;
using System.Windows;
using CommitAndForget.Converter;
using CommitAndForget.Model;

namespace CommitAndForget.Services.DataProvider
{
  public static class ImageDataProvider
  {
    public static ObservableCollection<ImageModel> LoadImages()
    {
      try
      {
        DataTable dt = DataBaseService.ExecuteSP("spGetImages");
        var imageList = new ObservableCollection<ImageModel>();
        if (dt is not null && dt.Rows.Count > 0)
        {
          foreach (DataRow row in dt.Rows)
          {
            var image = new ImageModel();
            image.Key = row["image_nKey"] != DBNull.Value ? (int)row["image_nKey"] : default;
            image.Approved = row["image_bApproved"] != DBNull.Value ? Convert.ToBoolean(row["image_bApproved"]) : default;
            image.CreationDate = row["image_dtCreationDate"] != DBNull.Value ? (DateTime)row["image_dtCreationDate"] : default;
            image.ContestWon = row["image_bContestWon"] != DBNull.Value ? Convert.ToBoolean(row["image_bContestWon"]) : default;

            // Bild aus LONGBLOB laden
            if (row["image_vbImage"] != DBNull.Value)
            {
              byte[] imageData = (byte[])row["image_vbImage"];
              image.Image = ByteArrayToBitmapImageConverter.LoadImage(imageData);
            }

            imageList.Add(image);
          }
        }
        return imageList;
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        return [];
      }
    }

    public static void SaveImage(ImageModel image)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_ImageKey", image.Key },
          { "p_Approved", image.Approved },
          { "p_ContestWon", image.ContestWon }
        };
        DataBaseService.ExecuteSP("spUpdateImage", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static ImageModel UploadImage(ImageModel image)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Image", ByteArrayToBitmapImageConverter.ConvertToDB(image.Image) }
        };
        DataTable dt = DataBaseService.ExecuteSP("spCreateImage", parameters);

        if (dt is not null && dt.Rows.Count == 1)
        {
          image.Key = dt.Rows[0]["nKey"] != DBNull.Value ? (int)dt.Rows[0]["nKey"] : default;
          return image;
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
      return null;
    }

    public static void DeleteImage(int imageKey)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Key", imageKey }
        };
        DataBaseService.ExecuteSP("spDeleteImage", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }
  }
}
