view: user_facts {
  derived_table: {
    sql: SELECT
        user_id,
        COALESCE(SUM(order_items.sale_price ), 0) AS lifetime_spend,
        COUNT(DISTINCT order_items.order_id ) AS lifetime_orders,
        min(order_items.created_at) as first_order_date,
        max(order_items.created_at) as latest_order_date,
        COUNT(*) AS lifetime_items
      FROM `ecomm.order_items`
           AS order_items
      group by 1
      ;;
  }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

  dimension: user_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.user_id ;;
    hidden: yes
  }

  dimension: lifetime_spend {
    type: number
    sql: ${TABLE}.lifetime_spend ;;
    hidden: yes
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
    hidden: yes
  }
  dimension: first_order_date {
    type: date
    sql: ${TABLE}.first_order_date ;;

  }
  dimension: latest_order_date {
    type: date
    sql: ${TABLE}.latest_order_date ;;

  }
  dimension: lifetime_items {
    type: number
    sql: ${TABLE}.lifetime_items ;;
    hidden: yes
  }

measure: average_lifetime_spend{
  type:  average
  sql: ${lifetime_spend} ;;
}

  measure: average_lifetime_orders{
    type:  average
    sql: ${lifetime_orders} ;;
  }

  measure: average_lifetime_items{
    type:  average
    sql: ${lifetime_items} ;;
  }

  set: detail {
    fields: [user_id, lifetime_spend, lifetime_orders, lifetime_items]
  }
}
