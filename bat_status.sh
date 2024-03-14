#!/bin/bash

bat_type=$(cat /sys/class/power_supply/qcom-battery/type)

if [ "$bat_type" != "Battery" ];then
	echo "未检测到你的电池信息"
	exit 0
fi

bat_status=$(cat /sys/class/power_supply/qcom-battery/status)
bat_health=$(cat /sys/class/power_supply/qcom-battery/health)	
bat_design=$(cat /sys/class/power_supply/qcom-battery/charge_full_design)
bat_percentage=$(cat /sys/class/power_supply/qcom-battery/capacity)

bat_status=${bat_status:-"获取失败"}
bat_health=${bat_health:-"获取失败"}
bat_design=${bat_design:-"获取失败"}
bat_percentage=${bat_percentage:-"0"}

if [ "$bat_status" == "Discharging" ];then
    bat_status="放电中"
elif [ "$bat_status" == "Charging" ];then 
    bat_status="充电中"
else
    bat_status="异常"
fi

if [ "$bat_design" != "获取失败" ];then
	bat_design=$(echo "scale=1; $bat_design/1000" | bc)
fi

if [ "$bat_health" == "Good" ];then
    bat_health="良好"
else
    bat_status="异常"
fi

echo "你的电池状态信息为："
echo "当前状态：$bat_status"
echo "当前电量：$bat_percentage %"
echo "设计容量：$bat_design mAh"
echo "电池健康：$bat_health"