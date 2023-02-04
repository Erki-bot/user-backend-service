class WalletController < ApplicationController
  def create
    uid = params["uid"]
    # raise "Missing the user uid" unless uid
    # raise "Incorrect uid" unless is_alphanumeric? uid
    render json: {id: "j"}, status: 200
  end
  def gets
    # response.body = {dpoihjdj: "Ok"}
    # render plain: 'Error Occurred', status: 500
    render json: {value: "Erki"}
  end

  private
    def is_alphanumeric?(string)
      string.match(/\A[a-zA-Z0-9]+\z/) != nil
    end

end
