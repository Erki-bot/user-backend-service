require 'httpx'
require_relative '../secret_generator'

class WalletController < ApplicationController
  def create
    uid = params["uid"]
    # puts "@@@@@@@uid : "
    # p uid
    if uid == nil
      render json: { error: "missing uid" }, status: 400
    elsif !is_alphanumeric? uid
      render json: { error: "incorrect uid. uid must be alphanumeric" }, status: 400
    else
      secret = secretGenerator 32
      response = HTTPX.post("http://localhost:8081/wallet", json: { uid: uid, secret: secret })
      # puts "response -----------------#{JSON.parse(response.body.to_s)}"
      # puts "error -----------------#{(response.error).class}"
      case response.status
      when 401
        render json: JSON.parse(response.body.to_s), status: 401
      when 201
        render json: { address: JSON.parse(response.body)["address"], password: secret }, status: 200
        # render json: JSON.parse(response.body.to_s), status: 200
      else
        render json: { error: "unknown error" }, status: 400
      end
    end
  end

  def gets
    # response.body = {dpoihjdj: "Ok"}
    # render plain: 'Error Occurred', status: 500
    render json: { value: "Erki" }
  end

  private

  def is_alphanumeric?(string)
    string.match(/\A[a-zA-Z0-9]+\z/) != nil
  end

end
