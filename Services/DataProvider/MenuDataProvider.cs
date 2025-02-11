using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using CommitAndForget.Converter;
using CommitAndForget.Model;

namespace CommitAndForget.Services.DataProvider
{
  public static class MenuDataProvider
  {
    public static ObservableCollection<MenuModel> LoadMenus()
    {
      try
      {
        DataTable dt = DataBaseService.ExecuteSP("spGetMenus");
        var menuList = new ObservableCollection<MenuModel>();

        if (dt is not null && dt.Rows.Count > 0)
        {
          foreach (DataRow row in dt.Rows)
          {
            // Menü nur hinzufügen, wenn noch nicht vorhanden
            int menuKey = row["menu_nKey"] != DBNull.Value ? (int)row["menu_nKey"] : default;
            var menu = menuList.FirstOrDefault(m => m.Key == menuKey);
            if (menu is null)
            {
              menu = new MenuModel();
              menu.Key = menuKey;
              menu.Name = row["menu_szName"] != DBNull.Value ? row["menu_szName"].ToString() ?? string.Empty : string.Empty;
              menu.Price = row["menu_rPrice"] != DBNull.Value ? (double)(decimal)row["menu_rPrice"] : default;

              var img = new ImageModel();
              img.Key = row["imageMenu_nKey"] != DBNull.Value ? (int)row["imageMenu_nKey"] : default;
              // Bild aus LONGBLOB laden
              if (row["imageMenu_vbImage"] != DBNull.Value)
              {
                byte[] imageData = (byte[])row["imageMenu_vbImage"];
                img.Image = ByteArrayToBitmapImageConverter.LoadImage(imageData);
              }
              menu.Image = img;

              menu.ProductList = new ObservableCollection<ProductModel>();

              menuList.Add(menu);
            }

            // Produkte zum Menü laden, wenn noch nicht vorhanden
            int productKey = row["product_nKey"] != DBNull.Value ? (int)row["product_nKey"] : default;
            var product = menu.ProductList.FirstOrDefault(p => p.Key == productKey);
            if (product is null)
            {
              product = new ProductModel();
              product.Key = productKey;
              product.Name = row["product_szName"] != DBNull.Value ? row["product_szName"].ToString() ?? string.Empty : string.Empty;
              product.Energy = row["product_nEnergy"] != DBNull.Value ? (int)row["product_nEnergy"] : default;
              product.Price = row["product_rPrice"] != DBNull.Value ? (double)(decimal)row["product_rPrice"] : default;
              product.Quantity = row["product_nQuantity"] != DBNull.Value ? (int)row["product_nQuantity"] : default;

              var img = new ImageModel();
              img.Key = row["imageProduct_nKey"] != DBNull.Value ? (int)row["imageProduct_nKey"] : default;
              // Bild aus LONGBLOB laden
              if (row["imageProduct_vbImage"] != DBNull.Value)
              {
                byte[] imageData = (byte[])row["imageProduct_vbImage"];
                img.Image = ByteArrayToBitmapImageConverter.LoadImage(imageData);
              }
              product.Image = img;

              product.Ingredients = new ObservableCollection<IngredientModel>();

              menu.ProductList.Add(product);
            }

            // Zutaten zum Produkt laden
            var ingredient = new IngredientModel();
            ingredient.Key = row["ingredient_nKey"] != DBNull.Value ? (int)row["ingredient_nKey"] : default;
            ingredient.Name = row["ingredient_szName"] != DBNull.Value ? row["ingredient_szName"].ToString() ?? string.Empty : string.Empty;
            ingredient.Quantity = row["ingredient_nQuantity"] != DBNull.Value ? (int)row["ingredient_nQuantity"] : default;

            product.Ingredients.Add(ingredient);
          }
        }
        return menuList;
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        return [];
      }
    }
  }
}
