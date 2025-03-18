using System.Collections.ObjectModel;
using System.Data;
using System.Windows;
using CommitAndForget.Model;

namespace CommitAndForget.Services.DataProvider
{
  public static class OrderDataProvider
  {
    public static int CreateOrder(int userLink, string paymentMethod)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_UserLink", userLink },
          { "p_PaymentMethod", paymentMethod },
          { "p_Paid", paymentMethod == "Cash" }
        };
        DataTable dt = DataBaseService.ExecuteSP("spCreateOrder", parameters);

        if (dt is not null && dt.Rows.Count > 0)
          return (int)dt.Rows[0]["newOrderID"];

      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
      return -1;
    }

    public static void AddProductsToOrder(ObservableCollection<ProductModel> productsToOrder, int orderLink)
    {
      try
      {
        foreach (var product in productsToOrder)
        {
          var parameters = new Dictionary<string, object>
          {
            { "p_OrderLink", orderLink },
            { "p_ProductLink", product.Key },
            { "p_Quantity", product.Quantity }
          };
          DataBaseService.ExecuteSP("spAddProductToOrder", parameters);
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    public static void AddMenusToOrder(ObservableCollection<MenuModel> menusToOrder, int orderLink)
    {
      try
      {
        foreach (var menu in menusToOrder)
        {
          var parameters = new Dictionary<string, object>
          {
            { "p_OrderLink", orderLink },
            { "p_MenuLink", menu.Key },
            { "p_Quantity", menu.Quantity }
          };
          DataBaseService.ExecuteSP("spAddMenuToOrder", parameters);
        }       
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }
  }
}
