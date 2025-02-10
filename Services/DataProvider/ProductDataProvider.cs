using CommitAndForget.Model;
using System.Collections.ObjectModel;
using System.Data;
using System.IO;
using System.Windows;
using System.Windows.Media.Imaging;

namespace CommitAndForget.Services.DataProvider
{
  public static class ProductDataProvider
  {
    public static ObservableCollection<ProductModel> LoadProducts()
    {
      try
      {
        DataTable dt = DataBaseService.ExecuteSP("spGetProducts");
        var productList = new ObservableCollection<ProductModel>();

        if (dt is not null && dt.Rows.Count > 0)
        {
          foreach (DataRow row in dt.Rows)
          {
            // Produkt nur hinzufügen, wenn noch nicht vorhanden
            int productKey = row["product_nKey"] != DBNull.Value ? (int)row["product_nKey"] : default;
            var product = productList.FirstOrDefault(p => p.Key == productKey);
            if (product is null)
            {
              product = new ProductModel();
              product.Key = productKey;
              product.Name = row["product_szName"] != DBNull.Value ? row["product_szName"].ToString() ?? string.Empty : string.Empty;
              product.Energy = row["product_nEnergy"] != DBNull.Value ? (int)row["product_nEnergy"] : default;
              product.Price = row["product_rPrice"] != DBNull.Value ? (double)(decimal)row["product_rPrice"] : default;

              var img = new ImageModel();
              img.Key = row["image_nKey"] != DBNull.Value ? (int)row["image_nKey"] : default;
              // Bild aus LONGBLOB laden
              if (row["image_vbImage"] != DBNull.Value)
              {
                byte[] imageData = (byte[])row["image_vbImage"];
                img.Image = LoadImage(imageData);
              }
              product.Image = img;

              product.Ingredients = new ObservableCollection<IngredientModel>();

              productList.Add(product);
            }

            // Zutaten zum Produkt laden
            var ingredient = new IngredientModel();
            ingredient.Key = row["ingredient_nKey"] != DBNull.Value ? (int)row["ingredient_nKey"] : default;
            ingredient.Name = row["ingredient_szName"] != DBNull.Value ? row["ingredient_szName"].ToString() ?? string.Empty : string.Empty;
            ingredient.Quantity = row["ingredient_nQuantity"] != DBNull.Value ? (int)row["ingredient_nQuantity"] : default;

            product.Ingredients.Add(ingredient);
          }
        }
        return productList;
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        return [];
      }
    }

    private static BitmapImage LoadImage(byte[] imageData)
    {
      using (var ms = new MemoryStream(imageData))
      {
        var image = new BitmapImage();
        image.BeginInit();
        image.CacheOption = BitmapCacheOption.OnLoad;
        image.StreamSource = ms;
        image.EndInit();
        image.Freeze(); // Optional: um das Bild thread-sicher zu machen
        return image;
      }
    }
  }
}
