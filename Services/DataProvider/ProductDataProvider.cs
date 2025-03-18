using CommitAndForget.Converter;
using CommitAndForget.Model;
using System.Collections.ObjectModel;
using System.Data;
using System.Windows;

namespace CommitAndForget.Services.DataProvider
{
  public static class ProductDataProvider
  {
    public static ObservableCollection<ProductModel> LoadProducts()
    {
      try
      {
        var parameters = new Dictionary<string, object>();

        DataTable dt = DataBaseService.ExecuteSP("spGetProducts", parameters);
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
              product.OrderCount = row["product_nOrderCount"] != DBNull.Value ? (int)row["product_nOrderCount"] : default;

              var img = new ImageModel();
              img.Key = row["image_nKey"] != DBNull.Value ? (int)row["image_nKey"] : default;
              // Bild aus LONGBLOB laden
              if (row["image_vbImage"] != DBNull.Value)
              {
                byte[] imageData = (byte[])row["image_vbImage"];
                img.Image = ByteArrayToBitmapImageConverter.LoadImage(imageData);
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

    public static void UpdateProduct(ProductModel product)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Key", product.Key },
          { "p_Name", product.Name },
          { "p_Energy", product.Energy },
          { "p_Price", product.Price },
          { "p_ImageLink", product.Image.Key == 0 ? null : product.Image.Key  }
        };
        DataBaseService.ExecuteSP("spUpdateProduct", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static void DeleteProduct(int productKey)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Key", productKey }
        };
        DataBaseService.ExecuteSP("spDeleteProduct", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static void DeleteProductsIngredients(int key)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Key", key }
        };
        DataBaseService.ExecuteSP("spDeleteProductIngredient", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static void AddProductIngredient(int productLink, int ingredientLink, double quantity)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_ProductLink", productLink },
          { "p_IngredientLink", ingredientLink },
          { "p_Quantity", quantity }
        };
        DataBaseService.ExecuteSP("spUpdateProductIngredient", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static int CreateProduct(ProductModel product)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Name", product.Name },
          { "p_Energy", product.Energy },
          { "p_Price", product.Price },
          { "p_ImageLink", product.Image.Key == 0 ? null : product.Image.Key }
        };
        DataTable dt = DataBaseService.ExecuteSP("spCreateProduct", parameters);
        return dt.Rows[0]["nKey"] != DBNull.Value ? Convert.ToInt32(dt.Rows[0]["nKey"]) : default;
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        return -1;

      }
    }
  }
}
