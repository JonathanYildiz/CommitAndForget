using CommitAndForget.Converter;
using CommitAndForget.Model;
using System.Collections.ObjectModel;
using System.Data;
using System.Windows;

namespace CommitAndForget.Services.DataProvider
{
  public static class ImageDataProvider
  {
    public static ObservableCollection<ImageModel> LoadImages(int userLink = 0)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_UserLink", userLink }
        };
        DataTable dt = DataBaseService.ExecuteSP("spGetImages", parameters);
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
            image.UploadedBy = row["image_szUploadedBy"] != DBNull.Value ? row["image_szUploadedBy"].ToString() ?? string.Empty : string.Empty;
            image.Rating = row["image_rRating"] != DBNull.Value ? Convert.ToDecimal(row["image_rRating"]) : default;

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

    public static ImageModel UploadImage(ImageModel image, int userLink)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Image", ByteArrayToBitmapImageConverter.ConvertToDB(image.Image) },
          { "p_UserLink", userLink }
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

    public static void ApproveImage(ImageModel currentContestImage)
    {
      try
      {
        if (currentContestImage is null)
          return;

        var parameters = new Dictionary<string, object>
        {
          { "p_ImageLink", currentContestImage.Key }
        };
        DataBaseService.ExecuteSP("spApproveImage", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static void SetRating(ImageModel selectedImage, int userLink)
    {
      try
      {
        if (selectedImage is null)
          return;

        var parameters = new Dictionary<string, object>
        {
          { "p_ImageLink", selectedImage.Key },
          { "p_ImageRating", selectedImage.Rating },
          { "p_UserLink", userLink }
        };
        DataBaseService.ExecuteSP("spRateImage", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static ObservableCollection<ImageModel> GetLastWinners()
    {
      try
      {
        DataTable dt = DataBaseService.ExecuteSP("spGetContestWinner");
        var winnerCollection = new ObservableCollection<ImageModel>();
        if (dt is not null && dt.Rows.Count > 0)
        {
          foreach (DataRow row in dt.Rows)
          {
            var image = new ImageModel();
            image.Key = row["image_nKey"] != DBNull.Value ? (int)row["image_nKey"] : default;
            image.UploadedBy = row["image_szUploadedBy"] != DBNull.Value ? row["image_szUploadedBy"].ToString() ?? string.Empty : string.Empty;

            // Sicherheitsüberprüfung: Keine Produktbilder
            if (image.UploadedBy == "admin")
              continue;

            // Bild aus LONGBLOB laden
            if (row["image_vbImage"] != DBNull.Value)
            {
              byte[] imageData = (byte[])row["image_vbImage"];
              image.Image = ByteArrayToBitmapImageConverter.LoadImage(imageData);
            }

            winnerCollection.Add(image);
          }
          return winnerCollection;
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
      return null;
    }
  }
}
