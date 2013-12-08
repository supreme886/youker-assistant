/*
 * Copyright (C) 2013 National University of Defense Technology(NUDT) & Kylin Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 1.1
import "common" as Common

Rectangle {
    id: weahterzone
    width: 208;height: 147
    SystemPalette { id: myPalette; colorGroup: SystemPalette.Active }
    color: "transparent"

    //设置[更换城市]按钮是否显示
    function resetChangeCityBtn() {
        var len = sessiondispatcher.getLengthOfCityList();
        if(len <= 1) {
            changeCityBtn.visible = false;
        }
        else {
            changeCityBtn.visible = true;
        }
    }

    //当启动时没有网络的时候，设置默认界面
    function setDefaultWeather() {
        weatherIcon.source = "../img/weather/d0.gif"
        locationText.text = qsTr("Unable to get weather data,");//无法获取天气数据，
        ptimeText.text = qsTr("please check network.");//请检查网络。
        weatherText.text = qsTr("Weather");//天气
        windText.text = qsTr("Wind");//风力
        pmText.text = qsTr("AQI");//空气质量指数
        tempText.text = qsTr("Current temperature（℃）");//当前温度（℃）
        temperatureRangeText.text = qsTr("Temperature range");//温度范围
        humidityText.text = qsTr("Humidity");//湿度
    }

    //设置天气数据到QML界面上
    function resetCurrentWeather() {
        var ptime = sessiondispatcher.getSingleWeatherInfo("ptime", "current");//eg: 08:00
        var need_str = ptime.substr(0, ptime.lastIndexOf(":"));//eg: 08
        //将字符串类型的时间转成整形
        var pIntTime = parseInt(need_str, 10);//eg: 8
        if(pIntTime > 7 && pIntTime < 20) {
            var img1 = sessiondispatcher.getSingleWeatherInfo("img1", "current");
            weatherIcon.source = sessiondispatcher.getSingleWeatherInfo(img1, "weathericon")
        }
        else {
            var img2 = sessiondispatcher.getSingleWeatherInfo("img2", "current");
            weatherIcon.source = sessiondispatcher.getSingleWeatherInfo(img2, "weathericon")
        }


        locationText.text = sessiondispatcher.getSingleWeatherInfo("city", "current");
        ptimeText.text = sessiondispatcher.getSingleWeatherInfo("time", "current") + qsTr(" release");// 发布
        weatherText.text = sessiondispatcher.getSingleWeatherInfo("weather", "current");
        windText.text = sessiondispatcher.getSingleWeatherInfo("WD", "current") + sessiondispatcher.getSingleWeatherInfo("WS", "current");
        var pmData = sessiondispatcher.get_current_pm25_qt();
        if (pmData == "N/A") {
            pmData = qsTr("N/A");//未知
        }
        pmText.text = qsTr("AQI:") + pmData;//空气质量指数：
        tempText.text = qsTr("Current temperature:") + sessiondispatcher.getSingleWeatherInfo("temp", "current") + "℃";//当前温度：
        temperatureRangeText.text = qsTr("Temperature range:") + sessiondispatcher.getSingleWeatherInfo("temp2", "current") + "~" + sessiondispatcher.getSingleWeatherInfo("temp1", "current");//温度范围：
        humidityText.text = qsTr("Humidity:") + sessiondispatcher.getSingleWeatherInfo("SD", "current");//湿度：
    }

    Connections
    {
        target: sessiondispatcher
        //用户修改了城市时更新
        onStartChangeQMLCity: {
            if(sessiondispatcher.get_current_weather_qt()) {
                weahterzone.resetCurrentWeather();
                weahterzone.resetChangeCityBtn();
            }
        }
        //自动更新时间到了的时候更新
        onStartUpdateRateTime: {
            updateTime.interval = 1000 * rate;
        }
    }

    Component.onCompleted: {
        var rate = sessiondispatcher.get_current_rate();
        updateTime.interval = 1000 * rate;
        if(sessiondispatcher.get_current_weather_qt()) {
            weahterzone.resetCurrentWeather();
            weahterzone.resetChangeCityBtn();
        }
        else {
            weahterzone.setDefaultWeather();
        }
    }
    Text {
        id: locationText
        text: qsTr("长沙")
        font.bold: true
        font.pixelSize: 14
        color: "#383838"
        anchors.left: parent.left
    }
    SetWord {
        id: changeCityBtn
        visible: false
        anchors.left: locationText.right
        wordname: qsTr("[Change City]")//[更换城市]
        width: 80
        height: 20
        flag: "ChangeCity"
    }
    Text {
        id: ptimeText
        text: qsTr("Release time")//发布时间
        font.bold: true
        font.pixelSize: 14
        color: "#383838"
        anchors.right: parent.right
    }
    Row {
        anchors.top: parent.top
        anchors.topMargin: 25
        spacing: 15
        Column {
            id: leftrow
            spacing: 5
            Image {
                id: weatherIcon
                width: 48; height: 48
                source: ""
//                source: "../img/weather/d0.gif"
            }

            SetWord {
                id: forecastBtn
                anchors.horizontalCenter: parent.horizontalCenter
                wordname: qsTr("Forecast")//预  报
                width: 40
                height: 20
                flag: "WeatherForecast"
            }
            SetWord {
                id: preferencesBtn
                anchors.horizontalCenter: parent.horizontalCenter
                wordname: qsTr("Preference")//配  置
                width: 40
                height: 20
                flag: "WeatherPreference"
            }
            Rectangle {
                width: 40
                height: 20
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    id:textname
                    anchors.centerIn: parent
                    text: qsTr("Update")//更  新
                    font.pointSize: 10
                    color: "#318d11"
                }
                Rectangle {
                    id: btnImg
                    anchors.top: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: textname.width
                    height: 1
                    color: "transparent"
                }
                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onEntered: btnImg.color = "#318d11"
                    onPressed: btnImg.color = "#318d11"
                    //要判断松开是鼠标位置
                    onReleased: btnImg.color = "#318d11"
                    onExited: btnImg.color = "transparent"
                    onClicked: {
                        if(sessiondispatcher.update_weather_data_qt()) {
                            weahterzone.resetCurrentWeather();
                            weahterzone.resetChangeCityBtn();
                            toolkits.alertMSG(qsTr("Update completed!"), mainwindow.pos.x, mainwindow.pos.y);//更新完毕！
                        }
                    }
                }
            }
        }

        Column {
            spacing: 5
            Text {
                id: weatherText
                text: qsTr("N/A")//未知
                font.pixelSize: 12
                color: "#7a7a7a"
            }
            Text {
                id: pmText
                text: qsTr("AQI:N/A")//空气质量指数：未知
                font.pixelSize: 12
                color: "#7a7a7a"
            }
            Text {
                id: tempText
                text: qsTr("Temperature:N/A")//温度：未知
                font.pixelSize: 12
                color: "#7a7a7a"
            }
            Text {
                id: humidityText
                text: qsTr("Humidity:N/A")//湿度：未知
                font.pixelSize: 12
                color: "#7a7a7a"
            }
            Text {
                id: temperatureRangeText
                text: qsTr("Temperature range:N/A")//温度范围：未知
                font.pixelSize: 12
                color: "#7a7a7a"
            }
            Text {
                id: windText
                text: qsTr("Wind:N/A")//风力未知
                font.pixelSize: 12
                color: "#7a7a7a"
            }
        }
    }
    Timer{
        id: updateTime
        interval: 60 * 1000;running: true;repeat: true
        onTriggered: {
            if(sessiondispatcher.get_current_weather_qt()) {
                weahterzone.resetCurrentWeather();
                weahterzone.resetChangeCityBtn();
            }
        }
    }
}
