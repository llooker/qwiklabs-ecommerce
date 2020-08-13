view: order_items {
  sql_table_name: `ecomm.order_items`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: shipping_days2 {
    type: duration
    sql_start: timestamp(${TABLE}.shipped_at) ;;
    sql_end: timestamp(${TABLE}.delivered_at) ;;
    intervals: [hour, day, week]
  }

  dimension: shipping_days1 {
    type: number
    sql: DATE_DIFF(${delivered_date},${shipped_date},DAY);;
  }



  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_sale_price  {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: average_sale_price  {
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price};;
    filters: [users.is_email: "Yes"]
    value_format_name: usd
  }

  measure: percentage_sales_email_source {
    type: number
    value_format_name: percent_2
    sql: 1.0*${total_sales_email_users}
      /NULLIF(${total_sale_price}, 0) ;;
  }

  measure: count_of_orders  {
  description:  "A count of unique orders"
    type: count_distinct
    sql: ${order_id} ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
