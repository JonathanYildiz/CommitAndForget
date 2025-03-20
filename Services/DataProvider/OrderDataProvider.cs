using System.Collections.ObjectModel;
using System.Data;
using System.Text;
using System.Windows;
using System.Windows.Controls;
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

    public static ObservableCollection<OrderModel> GetOrderHistory()
    {
      try
      {
        var orders = new ObservableCollection<OrderModel>();
        DataTable dt = DataBaseService.ExecuteSP("spGetOrderHistory");

        if (dt != null && dt.Rows.Count > 0)
        {
          foreach (DataRow row in dt.Rows)
          {
            var order = new OrderModel();
            order.Key = row["order_nKey"] != DBNull.Value ? (int)row["order_nKey"] : default;
            order.OrderDate = row["order_CreationDate"] != DBNull.Value ? (DateTime)row["order_CreationDate"] : default;
            order.TotalPrice = row["order_TotalPrice"] != DBNull.Value ? Convert.ToDouble(row["order_TotalPrice"].ToString()) : default;
            order.UserMail = row["user_Mail"] != DBNull.Value ? row["user_Mail"].ToString() ?? string.Empty : string.Empty;
            orders.Add(order);
          }
        }
        return orders;
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        return [];
      }
    }

    public static bool DeleteOrder(int orderId)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_OrderId", orderId }
        };
        DataTable dt = DataBaseService.ExecuteSP("spDeleteOrder", parameters);
        if (!dt.ExtendedProperties.ContainsKey("HasErrors"))
          return true;
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
      return false;
    }

    public static string GetOrderDetails(int orderId)
    {
      try
      {
        var orderDetails = new StringBuilder();
        var parameters = new Dictionary<string, object>
        {
          { "p_OrderId", orderId }
        };
        DataTable dt = DataBaseService.ExecuteSP("spGetOrderDetails", parameters);
        if (dt != null && dt.Rows.Count > 0)
        {
          foreach (DataRow row in dt.Rows)
          {
            string orderLine = "";
            orderLine += row["item_Name"] != DBNull.Value ? row["item_Name"].ToString() : string.Empty;
            orderLine += " ";
            orderLine += row["item_Quantity"] != DBNull.Value ? row["item_Quantity"].ToString() : string.Empty;
            orderLine += "x ";
            orderLine += row["item_Price"] != DBNull.Value ? row["item_Price"].ToString() : string.Empty;
            orderDetails.AppendLine(orderLine);
          }
        }
        return orderDetails.ToString();
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        return string.Empty;
      }
    }
  }
}
