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

  dimension: shipping_days {
    type: string
    sql: DATE_DIFF(${delivered_date},${shipped_date},day) ;;
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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_unique_orders {
    description: "A count of unique orders"
    type: count_distinct
    sql: ${inventory_item_id} ;;
  }

  measure: total_sales {
    description: "total of sale_price"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price} ;;
    filters:  {
      field: users.is_email_source
      value: "Yes"
    }
  }

  measure: average_sales {
    description: "average sales per order"
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: percentage_sales_email_source {
    type: percent_of_total
    value_format_name: decimal_2
    sql: 1.0*${total_sales_email_users} / NULLIF(${total_sales}, 0) ;;
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
