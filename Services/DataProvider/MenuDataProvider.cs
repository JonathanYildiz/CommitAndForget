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
              product.Quantity = row["product_nQuantity"] != DBNull.Value ? (int)row["product_nQuantity"] : default;

              menu.ProductList.Add(product);
            }
            
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

    public static void DeleteMenu(int menuKey)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Key", menuKey }
        };
        DataBaseService.ExecuteSP("spDeleteMenu", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static void UpdateMenu(MenuModel menu)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Key", menu.Key },
          { "p_Name", menu.Name },
          { "p_Price", menu.Price },
          { "p_ImageLink", menu.Image.Key == 0 ? null : menu.Image.Key  }
        };
        DataBaseService.ExecuteSP("spUpdateMenu", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static void DeleteMenuProduct(int key)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Key", key }
        };
        DataBaseService.ExecuteSP("spDeleteMenuProduct", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static void AddMenuProduct(int menuLink, int productLink, double quantity)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_MenuLink", menuLink },
          { "p_ProductLink", productLink },
          { "p_Quantity", quantity }
        };
        DataBaseService.ExecuteSP("spUpdateMenuProduct", parameters);
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static int CreateMenu(MenuModel menu)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_Name", menu.Name },
          { "p_Price", menu.Price },
          { "p_ImageLink", menu.Image.Key == 0 ? null : menu.Image.Key }
        };
        DataTable dt = DataBaseService.ExecuteSP("spCreateMenu", parameters);
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
