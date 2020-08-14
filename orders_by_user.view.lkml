view: orders_by_user {
  derived_table: {
    sql: SELECT
        user_id,
        COALESCE(SUM(order_items.sale_price ), 0) AS lifetime_revenue,
        COUNT(DISTINCT order_items.order_id ) AS lifetime_order_count,
        COUNT(*) AS lifetime_items,
        min(order_items.order_date) as first_order_date,
        max(order_items.order_date) as latest_order_date,
      FROM `ecomm.order_items`
           AS order_items
      group by 1
      limit 10
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_spend {
    type: number
    sql: ${TABLE}.lifetime_spend ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_items {
    type: number
    sql: ${TABLE}.lifetime_items ;;
  }

  set: detail {
    fields: [user_id, lifetime_spend, lifetime_orders, lifetime_items]
  }
}
